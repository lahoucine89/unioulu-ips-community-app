import 'package:appwrite/appwrite.dart';
import 'package:community/core/services/http_appwrite_service.dart';
import 'package:community/features/community/data/models/comment_model.dart';

class EventCommentService {
  final AppwriteService _appwriteService;

  EventCommentService({
    required AppwriteService appwriteService,
  }) : _appwriteService = appwriteService;

  String _eventReference(String eventId) => 'event::$eventId';

  Future<List<CommentModel>> getEventComments(String eventId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'comments',
        queries: [
          Query.equal('postId', _eventReference(eventId)),
          Query.orderDesc('\$createdAt'),
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
      }

      throw Exception('Failed to fetch event comments');
    } catch (e) {
      throw Exception('Failed to fetch event comments: $e');
    }
  }

  Future<CommentModel> addEventComment({
    required String eventId,
    required String text,
    required String username,
  }) async {
    if (username.trim().isEmpty || username == 'anonymous') {
      throw Exception('Anonymous users cannot add comments');
    }

    try {
      final response = await _appwriteService.createDocument(
        collectionId: 'comments',
        documentId: 'unique()',
        data: {
          'postId': _eventReference(eventId),
          'text': text.trim(),
          'username': username.trim(),
          'dateTime': DateTime.now().toIso8601String(),
        },
      );

      return response.containsKey('data')
          ? CommentModel.fromMap(response['data'])
          : CommentModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to add event comment: $e');
    }
  }

  Future<int> getEventCommentCount(String eventId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: 'comments',
        queries: [
          Query.equal('postId', _eventReference(eventId)),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        return (response['documents'] as List).length;
      }

      return 0;
    } catch (_) {
      return 0;
    }
  }
}
