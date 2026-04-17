import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobBoardPage extends StatelessWidget {
  const JobBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Job Board'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Student Job Portals'),
            const SizedBox(height: 12),
            ..._portals.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Part-Time & Freelance'),
            const SizedBox(height: 12),
            ..._partTime.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.search_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Job Board',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Find part-time jobs, internships, and thesis positions in Oulu and beyond.',
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

  static const _portals = [
    _Item(
      icon: Icons.work_outlined,
      title: 'University of Oulu Career Portal',
      description:
          'The university\'s official career portal lists internships, part-time jobs, thesis opportunities, and graduate positions from companies recruiting IPS students.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.computer_outlined,
      title: 'Tietokilta Job Board',
      description:
          'The IPS student guild Tietokilta maintains an active job board updated regularly with tech internships, part-time developer roles, and thesis work positions.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.business_center_outlined,
      title: 'TE-palvelut – Finnish Job Service',
      description:
          'The official Finnish employment service lists thousands of jobs across Finland. International students can apply for positions with a Finnish work permit.',
      url: 'https://www.te-palvelut.fi/',
    ),
    _Item(
      icon: Icons.people_alt_outlined,
      title: 'LinkedIn Jobs',
      description:
          'LinkedIn is the primary professional network for tech jobs in Finland. Set your location to Oulu or Finland and enable "Open to Work" to attract recruiters.',
      url: 'https://www.linkedin.com/jobs/',
    ),
  ];

  static const _partTime = [
    _Item(
      icon: Icons.access_time_outlined,
      title: 'Duunitori – Finnish Jobs',
      description:
          'Duunitori is one of Finland\'s largest job listing platforms covering part-time, summer, and full-time positions. Filter by Oulu and your field of study.',
      url: 'https://duunitori.fi/',
    ),
    _Item(
      icon: Icons.code_outlined,
      title: 'GitHub Jobs & Remote Work',
      description:
          'For software development roles, GitHub and remote work boards offer opportunities to work for international companies while studying in Oulu.',
      url: 'https://github.com/readme/guides/hiring-developers',
    ),
    _Item(
      icon: Icons.store_outlined,
      title: 'Monster Finland',
      description:
          'Monster Finland aggregates job listings across all sectors. Useful for finding student-friendly retail, hospitality, and service industry part-time work in Oulu.',
      url: 'https://www.monster.fi/',
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
