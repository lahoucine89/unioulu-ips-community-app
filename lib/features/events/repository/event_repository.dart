import 'dart:convert';
import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart';
import 'package:community/features/events/data/models/event_like_model.dart';

import '../data/models/event_model.dart';
import 'package:community/core/services/http_appwrite_service.dart';

class EventRepository {
  final AppwriteService appwriteService = AppwriteService();

  // Keep original signature exactly as it was
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await appwriteService.listDocuments(
        collectionId: "events",
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;
        developer.log('Successfully fetched ${documents.length} events');

        return documents
            .map((doc) => _parseEventDocument(doc))
            .whereType<EventModel>()
            .toList();
      } else {
        throw Exception('Failed to fetch events: ${response.toString()}');
      }
    } catch (e) {
      developer.log('Failed to fetch events: ${e.toString()}');
      throw Exception('Failed to fetch events: ${e.toString()}');
    }
  }

  // New method added without breaking old code
  Future<List<EventModel>> getEventsByTopic(String topicId) async {
    try {
      final response = await appwriteService.listDocuments(
        collectionId: "events",
        queries: [
          Query.contains('topics', [topicId]),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;
        developer.log(
          'Successfully fetched ${documents.length} events for topic $topicId',
        );

        return documents
            .map((doc) => _parseEventDocument(doc))
            .whereType<EventModel>()
            .toList();
      } else {
        throw Exception(
          'Failed to fetch events by topic: ${response.toString()}',
        );
      }
    } catch (e) {
      developer.log('Failed to fetch events by topic: ${e.toString()}');
      throw Exception('Failed to fetch events by topic: ${e.toString()}');
    }
  }

  // Get user's liked event IDs only
  Future<Set<String>> getUserLikedEventIds(String userId) async {
    if (userId == 'anonymous') {
      developer.log('Anonymous user has no liked event IDs');
      return <String>{};
    }

    try {
      developer.log('Fetching liked event IDs for user $userId');
      final response = await appwriteService.listDocuments(
        collectionId: "event_likes",
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;

        final likedIds = documents
            .map((doc) {
              try {
                if (doc is Map<String, dynamic>) {
                  return doc['eventId']?.toString();
                }

                final parsed = jsonDecode(jsonEncode(doc));
                return parsed['eventId']?.toString();
              } catch (e) {
                developer.log('Error parsing liked event ID: $e');
                return null;
              }
            })
            .whereType<String>()
            .toSet();

        developer.log(
          'Successfully fetched ${likedIds.length} liked event IDs',
        );

        return likedIds;
      }

      developer.log('No liked event IDs found or invalid response format');
      return <String>{};
    } catch (e) {
      developer.log('Failed to get liked event IDs: ${e.toString()}');
      return <String>{};
    }
  }

  // Keep existing method for compatibility
  Future<List<EventModel>> getUserLikedEvents(String userId) async {
    if (userId == 'anonymous') {
      developer.log('Anonymous user has no likes');
      return [];
    }

    try {
      developer.log('Fetching liked events for user $userId');

      final likedEventIds = await getUserLikedEventIds(userId);

      if (likedEventIds.isEmpty) {
        developer.log('No liked events found');
        return [];
      }

      final eventsResponse = await appwriteService.listDocuments(
        collectionId: 'events',
        queries: [
          Query.equal('\$id', likedEventIds.toList()),
        ],
      );

      if (eventsResponse.containsKey('documents') &&
          eventsResponse['documents'] is List) {
        final events = eventsResponse['documents'] as List;
        developer.log('Successfully fetched ${events.length} liked events');

        return events
            .map((doc) => _parseEventDocument(doc))
            .whereType<EventModel>()
            .toList();
      } else {
        developer.log('No events found for liked event IDs');
        return [];
      }
    } catch (e) {
      developer.log('Failed to get liked events: ${e.toString()}');
      return [];
    }
  }

  Future<void> toggleFavorite(
    String userId,
    String eventId,
    bool isFavorite,
  ) async {
    if (isFavorite) {
      await unlikeEvent(userId, eventId);
    } else {
      await likeEvent(userId, eventId);
    }
  }

  Future<Map<String, dynamic>> likeEvent(String userId, String eventId) async {
    if (userId == 'anonymous') {
      throw Exception('Anonymous users cannot like events');
    }

    final newLike = EventLikeModel(eventId: eventId, userId: userId);

    try {
      developer.log('Creating like document for user $userId, event $eventId');
      return await appwriteService.createDocument(
        collectionId: "event_likes",
        data: newLike.toJson(),
        documentId: 'unique()',
      );
    } catch (e) {
      developer.log('Failed to like event: ${e.toString()}');
      throw Exception('Failed to like event: ${e.toString()}');
    }
  }

  Future<void> unlikeEvent(String userId, String eventId) async {
    if (userId == 'anonymous') {
      throw Exception('Anonymous users cannot unlike events');
    }

    try {
      developer.log('Finding like document for user $userId, event $eventId');
      final response = await appwriteService.listDocuments(
        collectionId: "event_likes",
        queries: [
          Query.equal('userId', userId),
          Query.equal('eventId', eventId),
        ],
      );

      if (response.containsKey('documents') &&
          response['documents'] is List &&
          (response['documents'] as List).isNotEmpty) {
        final documentId = response['documents'][0]['\$id'];
        developer.log('Found like document with ID: $documentId, deleting...');

        await appwriteService.makeRequest(
          method: 'DELETE',
          endpointPath:
              'databases/${appwriteService.databaseId}/collections/event_likes/documents/$documentId',
        );

        developer.log('Successfully deleted like document');
      } else {
        developer.log('No like document found to delete');
      }
    } catch (e) {
      developer.log('Failed to unlike event: ${e.toString()}');
      throw Exception('Failed to unlike event: ${e.toString()}');
    }
  }

  Future<int> getEventLikeCount(String eventId) async {
    try {
      developer.log('Fetching like count for event $eventId');
      final response = await appwriteService.listDocuments(
        collectionId: "event_likes",
        queries: [
          Query.equal('eventId', eventId),
        ],
      );

      if (response.containsKey('documents') && response['documents'] is List) {
        final documents = response['documents'] as List;
        developer.log(
          'Successfully fetched ${documents.length} likes for event $eventId',
        );
        return documents.length;
      } else {
        throw Exception('Failed to fetch like count: ${response.toString()}');
      }
    } catch (e) {
      developer.log('Failed to fetch like count: ${e.toString()}');
      throw Exception('Failed to fetch like count: ${e.toString()}');
    }
  }

  EventModel? _parseEventDocument(dynamic doc) {
    try {
      if (doc is Map<String, dynamic>) {
        return EventModel.fromMap(doc['data'] ?? doc);
      }

      final parsed = jsonDecode(jsonEncode(doc));
      return EventModel.fromMap(parsed['data'] ?? parsed);
    } catch (e) {
      developer.log('Error parsing event document: $e');
      return null;
    }
  }
}
