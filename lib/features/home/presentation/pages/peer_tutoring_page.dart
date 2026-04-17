import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PeerTutoringPage extends StatelessWidget {
  const PeerTutoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Peer Tutoring'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Tutoring & Mentoring'),
            const SizedBox(height: 12),
            ..._tutoring.map((item) => _TutoringCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Study Groups & Communities'),
            const SizedBox(height: 12),
            ..._groups.map((item) => _TutoringCard(item: item, theme: theme)),
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
              Icons.people_outline,
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
                  'Peer Tutoring',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Get help from senior students and connect with study communities at IPS.',
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

  static const _tutoring = [
    _TutoringItem(
      icon: Icons.school_outlined,
      title: 'IPS Tutoring Programme',
      description:
          'IPS organises peer tutoring sessions where senior students help you with difficult courses. Contact the IPS student association or check Moodle for the current schedule.',
      url: 'https://www.oulu.fi/en/for-students/studying/student-tutoring',
    ),
    _TutoringItem(
      icon: Icons.group_outlined,
      title: 'Tietokilta – Student Guild',
      description:
          'The official student guild for IPS students. Tietokilta organises study support events, mentoring, and connects you with older students who can share their experience.',
      url: 'https://tietokilta.fi/',
    ),
    _TutoringItem(
      icon: Icons.connect_without_contact_outlined,
      title: 'University Mentoring',
      description:
          'The university\'s official mentoring programme pairs new international students with experienced student mentors. Sign up at the start of the academic year.',
      url: 'https://www.oulu.fi/en/for-students/studying/student-tutoring',
    ),
  ];

  static const _groups = [
    _TutoringItem(
      icon: Icons.forum_outlined,
      title: 'IPS Discord Community',
      description:
          'Join the IPS student Discord server to find study partners, ask course-specific questions, and stay updated on peer tutoring sessions and events.',
      url: 'https://discord.com/',
    ),
    _TutoringItem(
      icon: Icons.desktop_mac_outlined,
      title: 'Moodle Discussion Forums',
      description:
          'Each course on Moodle has a discussion forum where you can ask questions and collaborate with classmates. A great first stop when you\'re stuck.',
      url: 'https://moodle.oulu.fi/',
    ),
    _TutoringItem(
      icon: Icons.school_outlined,
      title: 'Mathematics & Science Support',
      description:
          'The Faculty of Information Technology and Electrical Engineering offers drop-in support sessions for mathematics and programming courses.',
      url: 'https://www.oulu.fi/en/university/faculties-and-units/faculty-information-technology-and-electrical-engineering',
    ),
  ];
}

class _TutoringItem {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _TutoringItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });
}

class _TutoringCard extends StatelessWidget {
  final _TutoringItem item;
  final ThemeData theme;

  const _TutoringCard({required this.item, required this.theme});

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
