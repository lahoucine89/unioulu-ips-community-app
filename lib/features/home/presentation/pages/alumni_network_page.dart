import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AlumniNetworkPage extends StatelessWidget {
  const AlumniNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Alumni Network'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Connect with Alumni'),
            const SizedBox(height: 12),
            ..._connect.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Mentoring & Career Guidance'),
            const SizedBox(height: 12),
            ..._mentoring.map((item) => _InfoCard(item: item, theme: theme)),
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
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
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
            child: Icon(Icons.people_alt_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alumni Network',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Connect with IPS graduates and tap into a global network of professionals.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(title,
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black));
  }

  static const _connect = [
    _Item(
      icon: Icons.people_alt_outlined,
      title: 'LinkedIn – IPS Alumni Group',
      description:
          'Search LinkedIn for the University of Oulu IPS alumni group. Connecting with graduates gives you access to job leads, career insights, and professional introductions.',
      url: 'https://www.linkedin.com/school/university-of-oulu/',
    ),
    _Item(
      icon: Icons.account_balance_outlined,
      title: 'University Alumni Association',
      description:
          'The University of Oulu alumni association connects graduates and current students through events, networking sessions, and mentoring programmes.',
      url: 'https://www.oulu.fi/en/alumni',
    ),
    _Item(
      icon: Icons.computer_outlined,
      title: 'Tietokilta Alumni',
      description:
          'Tietokilta maintains connections with IPS alumni who are now working in the tech industry. Guild events often include alumni guest speakers and networking opportunities.',
      url: 'https://tietokilta.fi/',
    ),
  ];

  static const _mentoring = [
    _Item(
      icon: Icons.school_outlined,
      title: 'University Mentoring Programme',
      description:
          'The university\'s formal mentoring programme pairs current students with experienced alumni professionals. Apply at the start of the academic year through Student Services.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.question_answer_outlined,
      title: 'Informational Interviews',
      description:
          'Reach out to alumni via LinkedIn for a short informational interview. Most are happy to share their career paths and advice — it\'s a powerful way to learn and network.',
      url: 'https://www.linkedin.com/',
    ),
    _Item(
      icon: Icons.event_outlined,
      title: 'Alumni Events & Talks',
      description:
          'Throughout the year, alumni return to campus for guest lectures, panel discussions, and networking evenings. Check the university event calendar to attend.',
      url: 'https://www.oulu.fi/en/events',
    ),
  ];
}

class _Item {
  final IconData icon;
  final String title;
  final String description;
  final String url;
  const _Item({required this.icon, required this.title, required this.description, required this.url});
}

class _InfoCard extends StatelessWidget {
  final _Item item;
  final ThemeData theme;
  const _InfoCard({required this.item, required this.theme});

  Future<void> _launch() async {
    final uri = Uri.parse(item.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
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
                child: Icon(item.icon, color: theme.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.title,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                        Icon(Icons.open_in_new_rounded, size: 16, color: theme.colorScheme.primary),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.description,
                        style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.45)),
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
