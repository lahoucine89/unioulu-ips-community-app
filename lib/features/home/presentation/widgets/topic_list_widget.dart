import 'package:flutter/material.dart';

import '../../../../core/services/http_appwrite_service.dart';
import '../../data/models/topic_model.dart';

class TopicListWidget extends StatelessWidget {
  final String currentLocale;
  final AppwriteService appwriteService;
  final Function(TopicModel)? onTopicSelected;
  final TopicModel? selectedTopic;

  const TopicListWidget({
    super.key,
    required this.currentLocale,
    required this.appwriteService,
    this.onTopicSelected,
    this.selectedTopic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 140,
        child: FutureBuilder<Map<String, dynamic>>(
          future: appwriteService.listDocuments(collectionId: "topics"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text('Error loading topics: ${snapshot.error}'),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!['documents'] == null) {
              return const Center(
                child: Text('Failed to load topics'),
              );
            }

            final List<dynamic> jsonData = snapshot.data!['documents'];

            if (jsonData.isEmpty) {
              return const Center(
                child: Text('No topics available'),
              );
            }

            final topics =
                jsonData.map((json) => TopicModel.fromJson(json)).toList();

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topics.length,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                final topic = topics[index];
                final topicText = _getLocalizedText(topic, currentLocale);
                final isSelected = selectedTopic?.id == topic.id;

                return GestureDetector(
                  onTap: () => onTopicSelected?.call(topic),
                  child: Container(
                    width: 92,
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getTopicIcon(topic),
                            color: Theme.of(context).colorScheme.primary,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          topicText,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getLocalizedText(TopicModel topic, String currentLocale) {
    switch (currentLocale) {
      case 'fi':
        return topic.textFi.isNotEmpty ? topic.textFi : topic.textEn;
      case 'sv':
        return topic.textSv.isNotEmpty ? topic.textSv : topic.textEn;
      default:
        return topic.textEn;
    }
  }

  IconData _getTopicIcon(TopicModel topic) {
    final rawIcon = topic.icon.trim().toLowerCase();
    final topicText = topic.textEn.trim().toLowerCase();

    switch (rawIcon) {
      case 'academic':
      case 'academy':
      case 'book':
      case 'school':
      case 'study':
      case 'menu_book':
      case '📚':
      case '🎓':
        return Icons.menu_book_outlined;

      case 'student life':
      case 'students':
      case 'community':
      case 'people':
      case 'groups':
      case '👥':
        return Icons.groups_outlined;

      case 'sports':
      case 'sport':
      case 'football':
      case 'soccer':
      case '⚽':
      case '🏀':
        return Icons.sports_soccer_outlined;

      case 'culture':
      case 'art':
      case 'theatre':
      case 'music':
      case '🎭':
      case '🎨':
        return Icons.palette_outlined;

      case 'career':
      case 'job':
      case 'work':
      case 'briefcase':
      case '💼':
        return Icons.work_outline;

      case 'research':
      case 'science':
      case 'lab':
      case 'experiment':
      case '🔬':
        return Icons.science_outlined;
    }

    if (topicText.contains('academic') || topicText.contains('academy')) {
      return Icons.menu_book_outlined;
    }

    if (topicText.contains('student')) {
      return Icons.groups_outlined;
    }

    if (topicText.contains('sport')) {
      return Icons.sports_soccer_outlined;
    }

    if (topicText.contains('culture')) {
      return Icons.palette_outlined;
    }

    if (topicText.contains('career')) {
      return Icons.work_outline;
    }

    if (topicText.contains('research')) {
      return Icons.science_outlined;
    }

    return Icons.category_outlined;
  }
}
