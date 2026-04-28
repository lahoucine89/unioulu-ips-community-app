import 'dart:developer' as developer;
import 'package:community/core/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../language/presentation/bloc/language_bloc.dart';
import '../../data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final double? width;
  
  const EventCard({
    super.key, 
    required this.event,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final String currentLocale = context
        .select((LocalizationBloc bloc) => bloc.state.locale.languageCode);
    
    // Calculate width based on parent constraints or use provided width
    final cardWidth = width ?? MediaQuery.of(context).size.width * 0.85;

    DateTime? eventDate;
    try {
      eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
    } catch (e) {
      developer.log('Error parsing event date: $e');
    }

    // Format the date according to locale if parsing succeeded
    final String formattedDate = eventDate != null
        ? DateFormat.yMMMd(currentLocale).format(eventDate)
        : event.date;

    // Wrap in IntrinsicHeight to use minimum required height
    return IntrinsicHeight(
      child: SizedBox(
        width: cardWidth,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Force minimum height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image with aspect ratio
                AspectRatio(
                  aspectRatio: 3 / 1, // Standard aspect ratio for event images
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Display event image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: event.posterPhotoUrl.trim().isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.black54,
                                  ),
                                )
                              : Image.network(
                                  event.posterPhotoUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.black54,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        // Favorite button in top-right corner
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: GestureDetector(
                            onTap: () {
                              // Handle favorite toggle logic here
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Icon(
                                Icons.bookmark_border_rounded,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                        // Price tag in bottom-left corner
                        Positioned(
                          bottom: 8.0,
                          left: 8.0,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              event.price,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                // Event Title
                Text(
                  event.titleEn,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                // Event Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        event.locationEn,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                // Event Date and Time
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text(
                      '|',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      event.time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}