import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyTipsPage extends StatelessWidget {
  const StudyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Study Tips'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Techniques & Methods'),
            const SizedBox(height: 12),
            ..._techniques.map((item) => _StudyCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Tools & Apps'),
            const SizedBox(height: 12),
            ..._tools.map((item) => _StudyCard(item: item, theme: theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4FB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.08),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.tips_and_updates_outlined,
              color: theme.colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Tips',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Proven techniques and tools to help you study smarter and perform better.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  static const _techniques = [
    _StudyItem(
      icon: Icons.timer_outlined,
      title: 'Pomodoro Technique',
      description:
          'Work in focused 25-minute sessions followed by a 5-minute break. After four rounds, take a longer break. This rhythm keeps your mind sharp and prevents burnout.',
      url: 'https://pomofocus.io/',
    ),
    _StudyItem(
      icon: Icons.psychology_outlined,
      title: 'Active Recall',
      description:
          'Instead of re-reading notes, test yourself on the material. Use flashcards, practice questions, or simply close your notes and write down what you remember.',
      url: 'https://www.youtube.com/watch?v=ukLnPbIffxE',
    ),
    _StudyItem(
      icon: Icons.repeat_outlined,
      title: 'Spaced Repetition',
      description:
          'Review material at increasing intervals over time. This technique is scientifically proven to move information into long-term memory more efficiently than cramming.',
      url: 'https://apps.ankiweb.net/',
    ),
    _StudyItem(
      icon: Icons.groups_outlined,
      title: 'Study Groups',
      description:
          'Studying with peers helps you fill gaps in your understanding, stay accountable, and approach problems from different angles. Form groups early in the study period.',
      url: 'https://moodle.oulu.fi/',
    ),
  ];

  static const _tools = [
    _StudyItem(
      icon: Icons.style_outlined,
      title: 'Anki – Flashcard App',
      description:
          'Create digital flashcards and use spaced repetition to memorise anything efficiently. Free on desktop and Android, available on iOS. Widely used by IPS students.',
      url: 'https://apps.ankiweb.net/',
    ),
    _StudyItem(
      icon: Icons.edit_note_outlined,
      title: 'Notion – Note Taking',
      description:
          'Organise your lecture notes, assignments, and study plans in one place. Notion\'s free plan is generous and works great for students managing multiple courses.',
      url: 'https://www.notion.so/',
    ),
    _StudyItem(
      icon: Icons.timer_outlined,
      title: 'Pomofocus – Pomodoro Timer',
      description:
          'A clean, browser-based Pomodoro timer to structure your study sessions. No sign-up needed — open it, set your task, and start the timer.',
      url: 'https://pomofocus.io/',
    ),
    _StudyItem(
      icon: Icons.cloud_outlined,
      title: 'Office 365 – University Tools',
      description:
          'University of Oulu students get free access to Microsoft Office 365, including Word, Excel, PowerPoint, OneDrive, and Teams for collaboration.',
      url: 'https://www.oulu.fi/en/for-students/it-services',
    ),
  ];
}

class _StudyItem {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _StudyItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });
}

class _StudyCard extends StatelessWidget {
  final _StudyItem item;
  final ThemeData theme;

  const _StudyCard({required this.item, required this.theme});

  Future<void> _launch() async {
    final uri = Uri.parse(item.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _launch,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.45,
                      ),
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
