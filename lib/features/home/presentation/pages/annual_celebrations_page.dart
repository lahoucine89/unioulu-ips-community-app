import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnualCelebrationsPage extends StatelessWidget {
  const AnnualCelebrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Annual Celebrations'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Finnish Student Traditions'),
            const SizedBox(height: 12),
            ..._traditions.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Guild & University Events'),
            const SizedBox(height: 12),
            ..._guild.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.festival_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Annual Celebrations',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Experience Finnish student traditions and university celebrations throughout the year.',
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

  static const _traditions = [
    _Item(
      icon: Icons.celebration_outlined,
      title: 'Wappu – May Day Celebrations',
      description:
          'Wappu (30 April – 1 May) is the biggest student celebration in Finland. Students gather in parks, sing songs, and attend parties in their student overalls (haalarit).',
      url: 'https://www.svy.fi/',
    ),
    _Item(
      icon: Icons.school_outlined,
      title: 'Fresher Week (Fuksivuosi)',
      description:
          'The first-year student experience in Finland is special. Freshers (fuksit) go through a fun initiation process involving challenges, events, and bonding with senior students.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.stars_outlined,
      title: 'Graduation Ceremonies',
      description:
          'University graduation ceremonies are celebrated twice a year. Graduates receive their degree certificates and celebrate with family and friends at the main hall.',
      url: 'https://www.oulu.fi/en/for-students/studying/graduation',
    ),
  ];

  static const _guild = [
    _Item(
      icon: Icons.cake_outlined,
      title: 'Tietokilta Anniversary Party',
      description:
          'Tietokilta celebrates its founding anniversary with a formal dinner party (vuosijuhla). This is one of the most prestigious events in the IPS student calendar.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.local_bar_outlined,
      title: 'Sitsit – Academic Dinner Events',
      description:
          'Sitsit are formal Finnish student dinner parties with songs, speeches, and toasts. Several guilds organise sitsit throughout the year — a true Finnish student tradition.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.event_outlined,
      title: 'University Event Calendar',
      description:
          'Stay informed about all upcoming celebrations, guild parties, and university events through the official university event calendar and the SYY social channels.',
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
