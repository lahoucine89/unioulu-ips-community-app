import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/main.dart' show locator;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/events_bloc.dart';
import '../bloc/events_state.dart';
import '../../data/models/event_model.dart';
import 'create_event_page.dart';
import 'event_detail_page.dart';
import 'events_calendar_page.dart';

enum EventFilter { all, today, week, month }

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  EventFilter _currentFilter = EventFilter.all;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final authRepository = locator<AuthRepositoryImpl>();
      String? userId;

      try {
        userId = await authRepository.getCurrentUserId();
      } catch (_) {
        userId = 'anonymous';
      }

      if (!mounted) return;

      context.read<EventsBloc>().add(FetchEvents(userId: userId));
    } catch (_) {}
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime? _parseEventDate(String rawDate) {
    final trimmedDate = rawDate.trim();
    if (trimmedDate.isEmpty) {
      return null;
    }

    final parsedDate = DateTime.tryParse(trimmedDate);
    if (parsedDate != null) {
      return _dateOnly(parsedDate);
    }

    try {
      return _dateOnly(DateFormat('yyyy-MM-dd').parseStrict(trimmedDate));
    } catch (_) {
      return null;
    }
  }

  List<EventModel> _applyFilter(List<EventModel> events) {
    if (_currentFilter == EventFilter.all) {
      return List<EventModel>.from(events);
    }

    final today = _dateOnly(DateTime.now());

    switch (_currentFilter) {
      case EventFilter.today:
        return events.where((event) {
          final date = _parseEventDate(event.date);
          if (date == null) return false;
          return date == today;
        }).toList();

      case EventFilter.week:
        final weekLater = today.add(const Duration(days: 7));
        return events.where((event) {
          final date = _parseEventDate(event.date);
          if (date == null) return false;
          return !date.isBefore(today) && !date.isAfter(weekLater);
        }).toList();

      case EventFilter.month:
        return events.where((event) {
          final date = _parseEventDate(event.date);
          if (date == null) return false;
          return date.year == today.year && date.month == today.month;
        }).toList();

      case EventFilter.all:
        return List<EventModel>.from(events);
    }
  }

  Widget _buildFilterButton(EventFilter filter, String text) {
    final isSelected = _currentFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterButton(EventFilter.all, 'All'),
            const SizedBox(width: 10),
            _buildFilterButton(EventFilter.today, 'Today'),
            const SizedBox(width: 10),
            _buildFilterButton(EventFilter.week, 'This Week'),
            const SizedBox(width: 10),
            _buildFilterButton(EventFilter.month, 'This Month'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              if (state is! EventsLoaded) {
                return const SizedBox();
              }

              return IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventsCalendarPage(
                        events: state.events,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'events_create_event',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CreateEventPage(),
            ),
          );
        },
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        label: const Text(
          'Create Event',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<EventsBloc, EventsState>(
              builder: (context, state) {
                if (state is EventsLoading || state is EventsInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is EventsError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is EventsLoaded) {
                  final events = _applyFilter(state.events);

                  if (events.isEmpty) {
                    return const Center(
                      child: Text('No events found'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _loadEvents,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _EventCard(event: event);
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text('No events state available'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;

  const _EventCard({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsPage(event: event),
            ),
          );
        },
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.08),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.event,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.titleEn,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${event.date} • ${event.time}',
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.locationEn,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
