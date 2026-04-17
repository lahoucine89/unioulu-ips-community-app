import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentClubsPage extends StatelessWidget {
  const StudentClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Clubs & Guilds'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Guilds & Associations'),
            const SizedBox(height: 12),
            ..._guilds.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'International & Social'),
            const SizedBox(height: 12),
            ..._social.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.group_work_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Clubs & Guilds',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Connect with student guilds, associations, and communities at the University of Oulu.',
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

  static const _guilds = [
    _Item(
      icon: Icons.computer_outlined,
      title: 'Tietokilta – IPS Student Guild',
      description:
          'The official student guild for IPS students. Tietokilta organises events, sauna nights, sports, and academic support, and represents IPS students at the university.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.groups_outlined,
      title: 'OTiT – IT Students\' Association',
      description:
          'OTiT is another IT-field student association at the University of Oulu. Open to all technology students, they host a variety of social and networking events.',
      url: 'https://otit.fi/',
    ),
    _Item(
      icon: Icons.account_balance_outlined,
      title: 'SYY – Student Union',
      description:
          'The Student Union of the University of Oulu (SYY) is the official student body. Joining SYY gives you access to student discounts, housing, and representation.',
      url: 'https://www.svy.fi/',
    ),
    _Item(
      icon: Icons.workspace_premium_outlined,
      title: 'All Student Guilds',
      description:
          'The University of Oulu has dozens of guilds across all faculties. Browse the full list on the Student Union website to find a community that matches your interests.',
      url: 'https://www.svy.fi/jasenliitot/',
    ),
  ];

  static const _social = [
    _Item(
      icon: Icons.flight_outlined,
      title: 'ESN Oulu – Erasmus Student Network',
      description:
          'ESN Oulu supports international and exchange students with events, trips, and a welcoming community. A great first stop for new arrivals looking to make friends.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.event_outlined,
      title: 'University Event Calendar',
      description:
          'Stay up to date with all student events, guild parties, sports competitions, and cultural happenings on the university\'s official event calendar.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.celebration_outlined,
      title: 'Tellus Innovation Arena',
      description:
          'Tellus is the vibrant student hub at Linnanmaa campus. It hosts coworking spaces, events, club meetups, and student organisation offices.',
      url: 'https://www.oulu.fi/en/university/campuses-and-services/tellus-innovation-arena',
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
