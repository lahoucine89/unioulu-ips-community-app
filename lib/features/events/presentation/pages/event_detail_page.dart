import 'dart:developer' as developer;

import 'package:community/core/services/http_appwrite_service.dart';
import 'package:community/core/utils/format_date.dart';
import 'package:community/core/widgets/custom_button.dart';
import 'package:community/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:community/features/community/data/models/comment_model.dart';
import 'package:community/features/events/presentation/bloc/events_bloc.dart';
import 'package:community/features/events/repository/event_repository.dart';
import 'package:community/features/events/service/event_comment_service.dart';
import 'package:community/features/surveys/presentation/pages/survey_intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
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

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late final EventCommentService _eventCommentService;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    _eventCommentService = EventCommentService(
      appwriteService: GetIt.instance<AppwriteService>(),
    );
    _loadCommentCount();
  }

  Future<void> _loadCommentCount() async {
    final count =
        await _eventCommentService.getEventCommentCount(widget.event.remoteId);
    if (mounted) {
      setState(() {
        _commentCount = count;
      });
    }
  }

  void _onCommentAdded() {
    _loadCommentCount();
  }

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
        length: 4,
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
              isScrollable: true,
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
              tabs: [
                const Tab(text: 'Info'),
                const Tab(text: 'Ticket'),
                const Tab(text: 'Location'),
                Tab(text: 'Comments ($_commentCount)'),
              ],
            ),
          ),
          body: Column(
            children: [
              EventLayout(event: widget.event),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  text: 'Take Survey',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurveyIntroPage(eventId: widget.event.remoteId),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _InfoTab(event: widget.event),
                    _TicketTab(event: widget.event),
                    _LocationTab(event: widget.event),
                    _CommentsTab(
                      event: widget.event,
                      service: _eventCommentService,
                      onCommentAdded: _onCommentAdded,
                    ),
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
                    userAgentPackageName: 'fi.oulu.ips.community',
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

class _CommentsTab extends StatefulWidget {
  final EventModel event;
  final EventCommentService service;
  final VoidCallback onCommentAdded;

  const _CommentsTab({
    required this.event,
    required this.service,
    required this.onCommentAdded,
  });

  @override
  State<_CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<_CommentsTab> {
  final TextEditingController _controller = TextEditingController();

  late final AuthRepositoryImpl _authRepository;

  List<CommentModel> _comments = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _authRepository = locator<AuthRepositoryImpl>();
    _loadComments();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final comments =
          await widget.service.getEventComments(widget.event.remoteId);

      if (mounted) {
        setState(() {
          _comments = comments;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load comments: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final username = await _authRepository.getCurrentUserName();

      await widget.service.addEventComment(
        eventId: widget.event.remoteId,
        text: text,
        username: username,
      );

      _controller.clear();
      await _loadComments();
      widget.onCommentAdded();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildComposer(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Join the discussion',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: 3,
            minLines: 2,
            decoration: InputDecoration(
              hintText: 'Write your comment about this event...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitComment,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_isSubmitting ? 'Posting...' : 'Post comment'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                child: Text(
                  comment.username.isNotEmpty
                      ? comment.username[0].toUpperCase()
                      : '?',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      formatDateTime(comment.dateTime),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment.text,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadComments,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildComposer(context),
          const SizedBox(height: 16),
          Text(
            'Comments (${_comments.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_comments.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'No comments yet. Be the first to comment on this event.',
              ),
            )
          else
            ..._comments.map(_buildCommentCard),
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
