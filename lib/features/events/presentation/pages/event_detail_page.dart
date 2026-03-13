import 'dart:developer' as developer;

import 'package:community/core/widgets/custom_button.dart';
import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/events/presentation/bloc/events_bloc.dart';
import 'package:community/features/events/repository/event_repository.dart';
import 'package:community/features/surveys/presentation/pages/survey_intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/event_model.dart';
import '../bloc/events_state.dart';
import 'package:community/main.dart' show locator;

Future<void> _loadEvents(BuildContext context) async {
  try {
    final authRepository = locator<AuthRepositoryImpl>();
    final eventsBloc = context.read<EventsBloc>();
    String? userId;

    try {
      userId = await authRepository.getCurrentUserId();
      developer.log('Loading events from EventLayout with userId: $userId');
    } catch (e) {
      developer.log('Error getting user ID: ${e.toString()}');
      userId = 'anonymous';
    }

    eventsBloc.add(FetchEvents(userId: userId));
  } catch (e) {
    developer.log(
      'Critical error loading events from EventLayout: ${e.toString()}',
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is EventsInitial) {
          _loadEvents(context);
        } else if (state is EventsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Event Details',
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            bottom: TabBar(
              indicator: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              unselectedLabelColor: Colors.white70,
              labelColor: Theme.of(context).primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Ticket'),
                Tab(text: 'Location'),
              ],
            ),
          ),
          body: Column(
            children: [
              EventLayout(event: event),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  text: 'Take Survey',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurveyIntroPage(eventId: event.remoteId),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _InfoTab(event: event),
                    _TicketTab(event: event),
                    _LocationTab(event: event),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final EventModel event;

  const _InfoTab({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.titleEn,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(event.locationEn),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text('${event.date} | ${event.time}'),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Icon(Icons.money, size: 16),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(event.price),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Icon(Icons.person, size: 16),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(event.organizerName),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(event.detailsEn),
        ],
      ),
    );
  }
}

class _TicketTab extends StatelessWidget {
  final EventModel event;

  const _TicketTab({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ticket Information',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(event.ticketDetailsEn),
        ],
      ),
    );
  }
}

class _LocationTab extends StatelessWidget {
  final EventModel event;

  const _LocationTab({
    required this.event,
  });

  static const LatLng _universityOfOulu = LatLng(65.0597, 25.4668);
  static const LatLng _sportsCenter = LatLng(65.0609, 25.4705);
  static const LatLng _kontinkangasCampus = LatLng(65.0019, 25.5108);
  static const LatLng _linnanmaaCampus = LatLng(65.0597, 25.4668);

  LatLng _resolveCoordinates() {
    final location = event.locationEn.toLowerCase();

    if (location.contains('sports center') || location.contains('sports')) {
      return _sportsCenter;
    }

    if (location.contains('kontinkangas')) {
      return _kontinkangasCampus;
    }

    if (location.contains('linnanmaa')) {
      return _linnanmaaCampus;
    }

    if (location.contains('university of oulu')) {
      return _universityOfOulu;
    }

    return _universityOfOulu;
  }

  String _resolveLocationTitle() {
    if (event.locationEn.trim().isNotEmpty) {
      return event.locationEn;
    }
    return 'University of Oulu';
  }

  @override
  Widget build(BuildContext context) {
    final mapPoint = _resolveCoordinates();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(_resolveLocationTitle()),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: mapPoint,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.community',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: mapPoint,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'Interactive map centered on ${_resolveLocationTitle()}. '
              'For exact event-by-event map positions, the backend should store latitude and longitude for each event.',
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

class EventLayout extends StatefulWidget {
  final EventModel event;

  const EventLayout({
    super.key,
    required this.event,
  });

  @override
  EventLayoutState createState() => EventLayoutState();
}

class EventLayoutState extends State<EventLayout> {
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchLikeCount();
  }

  Future<void> _fetchLikeCount() async {
    try {
      final eventService = EventRepository();
      final count = await eventService.getEventLikeCount(widget.event.remoteId);
      if (mounted) {
        setState(() {
          _likeCount = count;
        });
      }
    } catch (e) {
      developer.log('Error fetching like count: $e');
      if (mounted) {
        setState(() {
          _likeCount = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is EventsInitial) {
          developer.log('EventLayout detected EventsInitial, loading events');
          _loadEvents(context);
        }
      },
      builder: (context, state) {
        developer.log('Building EventLayout with state: ${state.runtimeType}');

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.event.posterPhotoUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFavoriteButton(context, state),
                    const SizedBox(width: 16.0),
                    TextButton.icon(
                      onPressed: () {
                        final String shareText =
                            'Check out this event: ${widget.event.titleEn}\n'
                            'Location: ${widget.event.locationEn}\n'
                            'Date: ${widget.event.date} | Time: ${widget.event.time}\n'
                            'Price: ${widget.event.price}';

                        Share.share(shareText);
                      },
                      label: const Text('Share'),
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteButton(BuildContext context, EventsState state) {
    final bool isFavorite = state is EventsLoaded &&
        state.favorites.contains(widget.event.remoteId);

    return TextButton.icon(
      onPressed: () {
        if (state is! EventsLoaded) {
          developer.log('State is not EventsLoaded, loading events first');
          _loadEvents(context);
          return;
        }

        developer.log(
          'Attempting to toggle favorite for event: ${widget.event.remoteId}',
        );

        context.read<EventsBloc>().add(
              ToggleFavorite(eventId: widget.event.remoteId),
            );

        setState(() {
          _likeCount += isFavorite ? -1 : 1;
        });
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      label: Text(
        _likeCount.toString(),
        style: TextStyle(
          color: isFavorite ? Colors.red : null,
        ),
      ),
    );
  }
}
