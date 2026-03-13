import 'dart:convert';
import 'package:community/features/community/data/models/poll_option.dart';

import 'comment_model.dart';

class PostModel {
  final String id;
  final String authorName;
  final String authorTitle;
  final String postTitle;
  final String content;
  final String imageUrl;
  final String pollQuestion;
  final List<CommentModel> comments;
  final List<PollOption> pollOptions;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorTitle,
    required this.postTitle,
    required this.content,
    required this.imageUrl,
    required this.pollQuestion,
    this.comments = const [],
    this.pollOptions = const [],
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory PostModel.fromMap(Map<String, dynamic> json) {
    List<CommentModel> commentsList = [];
    if (json['comments'] is List) {
      commentsList = (json['comments'] as List<dynamic>)
          .map((c) => CommentModel.fromMap(c as Map<String, dynamic>))
          .toList();
    } else if (json['comments'] is String) {
      try {
        final decodedComments = jsonDecode(json['comments'] as String);
        if (decodedComments is List) {
          commentsList = decodedComments
              .map((c) => CommentModel.fromMap(c as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
    }

    List<PollOption> pollOptionsList = [];
    final rawPollOptions = json['pollOptions'];

    if (rawPollOptions is List) {
      pollOptionsList = rawPollOptions
          .map((e) => PollOption.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (rawPollOptions is String && rawPollOptions.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawPollOptions);
        if (decoded is List) {
          pollOptionsList = decoded
              .map((e) =>
                  PollOption.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
        } else {
          pollOptionsList = PollOption.fromString(rawPollOptions);
        }
      } catch (_) {
        pollOptionsList = PollOption.fromString(rawPollOptions);
      }
    }

    return PostModel(
      id: json['\$id'] as String,
      authorName: json['authorName'] as String? ?? '',
      authorTitle: json['authorTitle'] as String? ?? '',
      postTitle: json['postTitle'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      pollQuestion: json['pollQuestion'] as String? ?? '',
      comments: commentsList,
      pollOptions: pollOptionsList,
      isLiked: json['isLiked'] as bool? ?? false,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorName': authorName,
      'authorTitle': authorTitle,
      'postTitle': postTitle,
      'content': content,
      'imageUrl': imageUrl,
      'pollQuestion': pollQuestion,
      'comments': comments.map((c) => c.toJson()).toList(),
      'pollOptions': jsonEncode(pollOptions.map((o) => o.toJson()).toList()),
      'isLiked': isLiked,
      'likeCount': likeCount,
      'commentCount': commentCount,
    };
  }

  void updateVote(int index) {
    if (index >= 0 && index < pollOptions.length) {
      pollOptions[index].votes++;
    }
  }

  PostModel copyWith({
    String? id,
    String? authorName,
    String? authorTitle,
    String? postTitle,
    String? content,
    String? imageUrl,
    String? pollQuestion,
    List<CommentModel>? comments,
    List<PollOption>? pollOptions,
    bool? isLiked,
    int? likeCount,
    int? commentCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorTitle: authorTitle ?? this.authorTitle,
      postTitle: postTitle ?? this.postTitle,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      pollQuestion: pollQuestion ?? this.pollQuestion,
      comments: comments ?? this.comments,
      pollOptions: pollOptions ?? this.pollOptions,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
