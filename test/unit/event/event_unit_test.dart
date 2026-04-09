import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/events/data/models/event_model.dart';
import 'package:community/features/events/presentation/bloc/events_bloc.dart';
import 'package:community/features/events/presentation/bloc/events_state.dart';
import 'package:community/features/events/repository/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'event_unit_test.mocks.dart';

@GenerateMocks([AuthRepositoryImpl, EventRepository])
void main() {
  late MockAuthRepositoryImpl mockAuthRepository;
  late MockEventRepository mockEventRepository;
  late EventsBloc eventsBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryImpl();
    mockEventRepository = MockEventRepository();
    eventsBloc = EventsBloc(
      eventRepository: mockEventRepository,
      authRepository: mockAuthRepository,
    );
  });

  test('emits EventsLoading, EventsLoaded when fetch events succeeds',
      () async {
    // Arrange

    final userId = 'user123';
    final event = createRandomEventModel(id: 'event123');
    final events = [event];

    when(mockAuthRepository.getCurrentUserId()).thenAnswer((_) async => userId);
    when(mockEventRepository.getEvents())
        .thenAnswer((_) async => events);
    when(mockEventRepository.getUserLikedEventIds(userId))
        .thenAnswer((_) async => <String>{});

    // Act
    eventsBloc.add(FetchEvents(userId: userId));

    // Assert
    expectLater(
      eventsBloc.stream,
      emitsInOrder([
        EventsLoading(),
        EventsLoaded(events: events, favorites: {}),
      ]),
    );

    // Clean up
    await eventsBloc.close();
  });
}


// Helper method to create a random EventModel for testing
EventModel createRandomEventModel({String? id}) {
  final now = DateTime.now();
  final eventId = id ?? 'event_${DateTime.now().millisecondsSinceEpoch}';
  
  return EventModel.create(
    id: eventId,
    posterPhotoUrl: 'https://example.com/images/event_$eventId.jpg',
    titleEn: 'Test Event $eventId (English)',
    titleFi: 'Test Event $eventId (Finnish)',
    titleSv: 'Test Event $eventId (Swedish)',
    locationEn: 'Test Location (English)',
    locationFi: 'Test Location (Finnish)',
    locationSv: 'Test Location (Swedish)',
    date: '2025-05-15',
    time: '18:00',
    price: 'Free',
    organizerName: 'Test Organizer',
    detailsEn: 'Test details in English',
    detailsFi: 'Test details in Finnish',
    detailsSv: 'Test details in Swedish',
    ticketDetailsEn: 'Ticket info in English',
    ticketDetailsFi: 'Ticket info in Finnish',
    ticketDetailsSv: 'Ticket info in Swedish',
    locationUrl: 'https://maps.google.com/?q=12345',
    topics: 'test,event,community',
    createdAt: now.subtract(const Duration(days: 7)),
    updatedAt: now,
  );
}