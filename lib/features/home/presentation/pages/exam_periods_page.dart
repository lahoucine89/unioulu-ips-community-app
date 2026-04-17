import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExamPeriodsPage extends StatelessWidget {
  const ExamPeriodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Exam Periods'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Registration & Schedules'),
            const SizedBox(height: 12),
            ..._registration.map((item) => _ExamCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Exam Preparation'),
            const SizedBox(height: 12),
            ..._preparation.map((item) => _ExamCard(item: item, theme: theme)),
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
              Icons.schedule_outlined,
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
                  'Exam Periods',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find your exam schedule, register for exams, and prepare effectively.',
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

  static const _registration = [
    _ExamItem(
      icon: Icons.app_registration_outlined,
      title: 'Peppi Student Portal',
      description:
          'Register for exams and check your personal exam schedule through the Peppi portal. Registration windows are usually open 1–2 weeks before the exam period.',
      url: 'https://peppi.oulu.fi/',
    ),
    _ExamItem(
      icon: Icons.calendar_month_outlined,
      title: 'Academic Calendar',
      description:
          'View the official University of Oulu academic calendar including study periods, exam dates, and public holidays for the current academic year.',
      url: 'https://www.oulu.fi/en/for-students/studying/academic-calendar',
    ),
    _ExamItem(
      icon: Icons.info_outline,
      title: 'Exam Rules & Guidelines',
      description:
          'Read the university\'s regulations on exam conduct, permitted materials, re-sit policies, and grading timelines before your exam.',
      url: 'https://www.oulu.fi/en/for-students/studying/exams',
    ),
  ];

  static const _preparation = [
    _ExamItem(
      icon: Icons.local_library_outlined,
      title: 'Past Exam Papers',
      description:
          'Access past exam papers through the university library or your course\'s Moodle page. Practising with old exams is one of the most effective ways to prepare.',
      url: 'https://oula.finna.fi/',
    ),
    _ExamItem(
      icon: Icons.desktop_mac_outlined,
      title: 'Moodle – Course Materials',
      description:
          'All lecture slides, practice exercises, and course resources are available on Moodle. Log in with your university credentials.',
      url: 'https://moodle.oulu.fi/',
    ),
    _ExamItem(
      icon: Icons.support_agent_outlined,
      title: 'Study Skills Support',
      description:
          'The university\'s Language and Communication Studies unit offers workshops on academic writing and exam techniques open to all IPS students.',
      url: 'https://www.oulu.fi/en/for-students/studying/language-and-communication-studies',
    ),
  ];
}

class _ExamItem {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _ExamItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });
}

class _ExamCard extends StatelessWidget {
  final _ExamItem item;
  final ThemeData theme;

  const _ExamCard({required this.item, required this.theme});

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
