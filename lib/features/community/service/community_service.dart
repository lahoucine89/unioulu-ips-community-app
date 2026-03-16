import 'dart:convert';
import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart';
import 'package:community/core/services/http_appwrite_service.dart';
import 'package:community/features/community/data/models/comment_model.dart';
import 'package:community/features/community/data/models/post_model.dart';

class CommunityService {
  final AppwriteService _appwriteService;

  CommunityService({required AppwriteService appwriteService})
      : _appwriteService = appwriteService;

  Future<void> voteOnPoll(String postId, int optionIndex) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'posts',
        queries: [
          Query.equal('\$id', postId),
        ],
      );

      if (!response.containsKey('documents') ||
          response['documents'] is! List ||
          (response['documents'] as List).isEmpty) {
        throw Exception('Post not found');
      }

      final document = (response['documents'] as List).first;
      final rawPollOptions = document['pollOptions'];

      List<Map<String, dynamic>> pollOptions = [];

      if (rawPollOptions is String && rawPollOptions.isNotEmpty) {
        try {
          final decoded = jsonDecode(rawPollOptions);

          if (decoded is List) {
            pollOptions = decoded
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          } else {
            throw Exception('Invalid poll options format');
          }
        } catch (_) {
          final parts = rawPollOptions
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

          pollOptions = parts
              .map((option) => {
                    'option': option,
                    'votes': 0,
                  })
              .toList();
        }
      } else if (rawPollOptions is List) {
        pollOptions = rawPollOptions
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } else {
        throw Exception('Poll options not found in post');
      }

      if (optionIndex < 0 || optionIndex >= pollOptions.length) {
        throw Exception('Invalid poll option index');
      }

      final updatedPollOptions = pollOptions.asMap().entries.map((entry) {
        final index = entry.key;
        final option = Map<String, dynamic>.from(entry.value);

        if (index == optionIndex) {
          final currentVotes = option['votes'] is int
              ? option['votes'] as int
              : int.tryParse(option['votes'].toString()) ?? 0;

          option['votes'] = currentVotes + 1;
        }

        return option;
      }).toList();

      await _appwriteService.updateDocument(
        collectionId: 'posts',
        documentId: document['\$id'],
        data: {
          'pollOptions': jsonEncode(updatedPollOptions),
        },
      );
    } catch (e) {
      throw Exception('Failed to vote on poll: $e');
    }
  }

  Future<List<dynamic>> getUserLikedCommentIds(String userId) async {
    if (userId == 'anonymous') {
      developer.log('Anonymous user has no likes');
      return [];
    }

    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'comment_likes',
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;
        return documents.map((doc) => doc['commentId']).toList();
      } else {
        throw Exception('Failed to fetch liked comment IDs');
      }
    } catch (e) {
      throw Exception('Failed to fetch liked comment IDs: $e');
    }
  }

  Future<List<PostModel>> getPosts({
    int? limit = 50,
    bool sortByLatest = true,
  }) async {
    final List<String> queries = [];

    if (sortByLatest) {
      queries.add(Query.orderDesc('\$createdAt'));
    }

    if (limit != null) {
      queries.add(Query.limit(limit));
    }

    final response = await _appwriteService.listDocuments(
      collectionId: 'posts',
      queries: queries,
    );

    if (response.containsKey('documents') && response['documents'] is List) {
      final documents = response['documents'] as List;

      final posts = documents
          .map((doc) {
            try {
              if (doc is Map<String, dynamic>) {
                return PostModel.fromMap(doc['data'] ?? doc);
              }
              return null;
            } catch (_) {
              return null;
            }
          })
          .whereType<PostModel>()
          .toList();

      final postIds = posts.map((p) => p.id).toList();

      final likeCounts = await getPostLikeCounts(postIds);
      final commentCounts = await getPostCommentCounts(postIds);

      for (int i = 0; i < posts.length; i++) {
        final likeCount = likeCounts[posts[i].id] ?? 0;
        final commentCount = commentCounts[posts[i].id] ?? 0;

        posts[i] = posts[i].copyWith(
          likeCount: likeCount,
          commentCount: commentCount,
        );
      }

      return posts;
    } else {
      throw Exception('Failed to fetch posts: ${response.toString()}');
    }
  }

  Future<CommentModel> addComment(
    String postId,
    String text,
    String username,
    String userId, {
    String? parentCommentId,
  }) async {
    if (username == 'anonymous' || userId == 'anonymous') {
      throw Exception('Anonymous users cannot add comments');
    }

    try {
      final Map<String, dynamic> data = {
        'postId': postId,
        'text': text,
        'username': username,
        'userId': userId,
        'dateTime': DateTime.now().toIso8601String(),
      };

      if (parentCommentId != null && parentCommentId.trim().isNotEmpty) {
        data['parentCommentId'] = parentCommentId;
      }

      final response = await _appwriteService.createDocument(
        collectionId: 'comments',
        data: data,
        documentId: 'unique()',
      );

      return response.containsKey('data')
          ? CommentModel.fromMap(response['data'])
          : CommentModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<List<CommentModel>> getPostComments(String postId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'comments',
        queries: [
          Query.equal('postId', postId),
          Query.orderAsc('dateTime'),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;

        return documents
            .map((doc) {
              try {
                if (doc is Map<String, dynamic>) {
                  return CommentModel.fromMap(doc['data'] ?? doc);
                }
                return null;
              } catch (_) {
                return null;
              }
            })
            .whereType<CommentModel>()
            .toList();
      } else {
        throw Exception('Failed to fetch comments: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('Failed to fetch comments: ${e.toString()}');
    }
  }

  Future<int> getPostLikeCount(String postId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'post_likes',
        queries: [
          Query.equal('postId', postId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        return (response['documents'] as List).length;
      } else {
        throw Exception('Failed to fetch like count: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('Failed to fetch like count: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getUserLikedPosts(String userId) async {
    if (userId == 'anonymous') {
      developer.log('Anonymous user has no likes');
      return [];
    }

    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'post_likes',
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final postLikes = response['documents'] as List;

        if (postLikes.isEmpty) {
          developer.log('No likes found for user');
          return [];
        }

        final likedPostIds =
            postLikes.map((doc) => doc['postId'].toString()).toList();

        final postsResponse = await _appwriteService.listDocuments(
          collectionId: 'posts',
          queries: [
            Query.equal('\$id', likedPostIds),
          ],
        );

        if (postsResponse.containsKey('documents') &&
            postsResponse['documents'] is List) {
          final posts = postsResponse['documents'] as List;

          return posts
              .map((doc) {
                try {
                  if (doc is Map<String, dynamic>) {
                    return PostModel.fromMap(doc['data'] ?? doc);
                  }
                  return PostModel.fromMap(jsonDecode(jsonEncode(doc)));
                } catch (_) {
                  return null;
                }
              })
              .whereType<PostModel>()
              .toList();
        } else {
          return [];
        }
      }

      return [];
    } catch (e) {
      developer.log('Failed to get liked posts: ${e.toString()}');
      return [];
    }
  }

  Future<Map<String, dynamic>> likeComment(
    String userId,
    String commentId,
  ) async {
    if (userId == 'anonymous') {
      throw Exception('Anonymous users cannot like comments');
    }

    final newLike = {
      'commentId': commentId,
      'userId': userId,
    };

    try {
      return await _appwriteService.createDocument(
        collectionId: 'comment_likes',
        data: newLike,
        documentId: 'unique()',
      );
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<Map<String, dynamic>> likePost(String userId, String postId) async {
    if (userId == 'anonymous') {
      throw Exception('Anonymous users cannot like posts');
    }

    final newLike = {
      'postId': postId,
      'userId': userId,
    };

    try {
      return await _appwriteService.createDocument(
        collectionId: 'post_likes',
        data: newLike,
        documentId: 'unique()',
      );
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  Future<void> unlikeComment(String userId, String commentId) async {
    if (userId == 'anonymous') {
      throw Exception('Anonymous users cannot unlike comments');
    }

    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'comment_likes',
        queries: [
          Query.equal('commentId', commentId),
          Query.equal('userId', userId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;

        if (documents.isEmpty) {
          throw Exception('Like document not found');
        }

        final likeDocument = documents.first;
        final likeDocumentId = likeDocument['\$id'];

        await _appwriteService.deleteDocument(
          collectionId: 'comment_likes',
          documentId: likeDocumentId,
        );
      } else {
        throw Exception(
          'Failed to fetch like document: ${response.toString()}',
        );
      }
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }

  Future<void> unlikePost(String userId, String postId) async {
    if (userId == 'anonymous') {
      throw Exception('Anonymous users cannot unlike posts');
    }

    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'post_likes',
        queries: [
          Query.equal('postId', postId),
          Query.equal('userId', userId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;

        if (documents.isEmpty) {
          throw Exception('Like document not found');
        }

        final likeDocument = documents.first;
        final likeDocumentId = likeDocument['\$id'];

        await _appwriteService.deleteDocument(
          collectionId: 'post_likes',
          documentId: likeDocumentId,
        );
      } else {
        throw Exception(
          'Failed to fetch like document: ${response.toString()}',
        );
      }
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  Future<Map<String, int>> getCommentLikeCounts(List<String> commentIds) async {
    try {
      final Map<String, int> likeCounts = {
        for (final id in commentIds) id: 0,
      };

      if (commentIds.isEmpty) return likeCounts;

      final response = await _appwriteService.listDocuments(
        collectionId: 'comment_likes',
        queries: [
          Query.equal('commentId', commentIds),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final likes = response['documents'] as List;

        for (final like in likes) {
          final commentId = like['commentId'];
          if (likeCounts.containsKey(commentId)) {
            likeCounts[commentId] = (likeCounts[commentId] ?? 0) + 1;
          }
        }
      }

      return likeCounts;
    } catch (e) {
      throw Exception('Failed to fetch like counts: ${e.toString()}');
    }
  }

  Future<Map<String, int>> getPostLikeCounts(List<String> postIds) async {
    try {
      final Map<String, int> likeCounts = {
        for (final id in postIds) id: 0,
      };

      if (postIds.isEmpty) return likeCounts;

      final response = await _appwriteService.listDocuments(
        collectionId: 'post_likes',
        queries: [
          Query.equal('postId', postIds),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final likes = response['documents'] as List;

        for (final like in likes) {
          final postId = like['postId'];
          if (likeCounts.containsKey(postId)) {
            likeCounts[postId] = (likeCounts[postId] ?? 0) + 1;
          }
        }
      }

      return likeCounts;
    } catch (e) {
      throw Exception('Failed to fetch like counts: ${e.toString()}');
    }
  }

  Future<Map<String, int>> getPostCommentCounts(List<String> postIds) async {
    try {
      final Map<String, int> commentCounts = {
        for (final id in postIds) id: 0,
      };

      if (postIds.isEmpty) return commentCounts;

      final response = await _appwriteService.listDocuments(
        collectionId: 'comments',
        queries: [
          Query.equal('postId', postIds),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final comments = response['documents'] as List;

        for (final comment in comments) {
          final postId = comment['postId'];
          if (commentCounts.containsKey(postId)) {
            commentCounts[postId] = (commentCounts[postId] ?? 0) + 1;
          }
        }
      }

      return commentCounts;
    } catch (e) {
      throw Exception('Failed to fetch comment counts: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getPostLikes(String postId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'post_likes',
        queries: [
          Query.equal('postId', postId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;

        return documents
            .map((doc) {
              try {
                if (doc is Map<String, dynamic>) {
                  return PostModel.fromMap(doc['data'] ?? doc);
                }
                return null;
              } catch (_) {
                return null;
              }
            })
            .whereType<PostModel>()
            .toList();
      } else {
        throw Exception('Failed to fetch likes: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('Failed to fetch likes: ${e.toString()}');
    }
  }
}
