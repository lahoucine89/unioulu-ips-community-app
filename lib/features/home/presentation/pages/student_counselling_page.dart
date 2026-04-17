import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCounsellingPage extends StatelessWidget {
  const StudentCounsellingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Counselling'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Academic Support'),
            const SizedBox(height: 12),
            ..._academic.map((item) => _CounsellingCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Wellbeing & Health'),
            const SizedBox(height: 12),
            ..._wellbeing.map((item) => _CounsellingCard(item: item, theme: theme)),
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
              Icons.support_agent_outlined,
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
                  'Student Counselling',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Academic guidance, personal support, and health services for IPS students.',
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

  static const _academic = [
    _CounsellingItem(
      icon: Icons.support_agent_outlined,
      title: 'IPS Study Counsellor',
      description:
          'The IPS study counsellor can help you plan your degree, select electives, and resolve academic challenges. Book an appointment via the student services portal.',
      url: 'https://www.oulu.fi/en/for-students/student-services',
    ),
    _CounsellingItem(
      icon: Icons.school_outlined,
      title: 'Student Services',
      description:
          'The university\'s Student Services team handles admissions, study right, credit transfers, and graduation matters. Contact them for official academic inquiries.',
      url: 'https://www.oulu.fi/en/for-students/student-services',
    ),
    _CounsellingItem(
      icon: Icons.public_outlined,
      title: 'International Student Support',
      description:
          'Dedicated support for international students including visa guidance, residence permits, and settling into life in Finland. Available through the International Office.',
      url: 'https://www.oulu.fi/en/for-students/international-students',
    ),
    _CounsellingItem(
      icon: Icons.accessibility_new_outlined,
      title: 'Accessibility Services',
      description:
          'Students with disabilities or learning difficulties can request special arrangements for exams and coursework through the university\'s accessibility services.',
      url: 'https://www.oulu.fi/en/for-students/student-services/support-for-students-with-disabilities',
    ),
  ];

  static const _wellbeing = [
    _CounsellingItem(
      icon: Icons.local_hospital_outlined,
      title: 'FSHS – Student Health Service',
      description:
          'The Finnish Student Health Service (FSHS) provides healthcare, mental health support, and dental services. Register online to book appointments at the Oulu unit.',
      url: 'https://www.yths.fi/en/',
    ),
    _CounsellingItem(
      icon: Icons.psychology_outlined,
      title: 'Mental Health Support',
      description:
          'FSHS offers free psychological counselling sessions for students experiencing stress, anxiety, or other mental health concerns. You can book appointments online.',
      url: 'https://www.yths.fi/en/services/mental-health/',
    ),
    _CounsellingItem(
      icon: Icons.church_outlined,
      title: 'University Chaplaincy',
      description:
          'The university chaplain offers confidential discussions and pastoral care to all students regardless of religion. A good resource when you need someone to talk to.',
      url: 'https://www.oulu.fi/en/for-students/student-services/chaplaincy',
    ),
  ];
}

class _CounsellingItem {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _CounsellingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });
}

class _CounsellingCard extends StatelessWidget {
  final _CounsellingItem item;
  final ThemeData theme;

  const _CounsellingCard({required this.item, required this.theme});

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
