import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseRegistrationPage extends StatelessWidget {
  const CourseRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Course Registration'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Registration Portals'),
            const SizedBox(height: 12),
            ..._portals.map((item) => _RegistrationCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Study Planning'),
            const SizedBox(height: 12),
            ..._planning.map((item) => _RegistrationCard(item: item, theme: theme)),
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
              Icons.app_registration_outlined,
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
                  'Course Registration',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Register for courses, plan your degree, and manage your study schedule.',
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

  static const _portals = [
    _RegistrationItem(
      icon: Icons.app_registration_outlined,
      title: 'Peppi – Student Portal',
      description:
          'The main portal for course and exam registration at the University of Oulu. Registration windows open at the start of each study period — register early as popular courses fill up fast.',
      url: 'https://peppi.oulu.fi/',
    ),
    _RegistrationItem(
      icon: Icons.desktop_mac_outlined,
      title: 'Moodle – Course Platform',
      description:
          'After registering, enrol in your course\'s Moodle page to access all learning materials, assignments, and communication channels.',
      url: 'https://moodle.oulu.fi/',
    ),
    _RegistrationItem(
      icon: Icons.language_outlined,
      title: 'Course Catalogue',
      description:
          'Browse the full list of available courses, their content descriptions, credit loads, and prerequisites through the university\'s online study guide.',
      url: 'https://www.oulu.fi/en/for-students/studying/study-guide',
    ),
  ];

  static const _planning = [
    _RegistrationItem(
      icon: Icons.map_outlined,
      title: 'Personal Study Plan (HOPS)',
      description:
          'Create and manage your personal study plan (HOPS) in Peppi. A well-structured HOPS helps you graduate on time and ensures all degree requirements are met.',
      url: 'https://peppi.oulu.fi/',
    ),
    _RegistrationItem(
      icon: Icons.schema_outlined,
      title: 'Degree Requirements',
      description:
          'Check the exact credit requirements and compulsory courses for your IPS degree programme in the university study guide.',
      url: 'https://www.oulu.fi/en/for-students/studying/study-guide',
    ),
    _RegistrationItem(
      icon: Icons.support_agent_outlined,
      title: 'Study Counsellor',
      description:
          'Need help choosing your courses or planning your degree path? Book a session with the IPS study counsellor through the university\'s student services portal.',
      url: 'https://www.oulu.fi/en/for-students/student-services',
    ),
  ];
}

class _RegistrationItem {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _RegistrationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });
}

class _RegistrationCard extends StatelessWidget {
  final _RegistrationItem item;
  final ThemeData theme;

  const _RegistrationCard({required this.item, required this.theme});

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
