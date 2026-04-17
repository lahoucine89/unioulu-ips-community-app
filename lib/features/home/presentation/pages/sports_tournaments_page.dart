import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SportsTournamentsPage extends StatelessWidget {
  const SportsTournamentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Upcoming Tournaments'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'University Competitions'),
            const SizedBox(height: 12),
            ..._competitions.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'National & Regional Events'),
            const SizedBox(height: 12),
            ..._national.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.emoji_events_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming Tournaments',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Compete in university and national student sports tournaments throughout the year.',
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

  static const _competitions = [
    _Item(
      icon: Icons.event_outlined,
      title: 'UniSport Tournament Calendar',
      description:
          'UniSport Oulu publishes a schedule of intramural and inter-guild tournaments covering football, floorball, basketball, volleyball, and more throughout the year.',
      url: 'https://www.unisport.fi/oulu/',
    ),
    _Item(
      icon: Icons.groups_outlined,
      title: 'Inter-Guild Sports Day',
      description:
          'Several times per year, student guilds compete against each other in a friendly sports day. Tietokilta regularly participates — watch the guild\'s channels for sign-ups.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.sports_score_outlined,
      title: 'Campus League (Kampusliiga)',
      description:
          'The campus sports league runs team competitions in multiple sports across the academic year. Register your team early as spots are limited.',
      url: 'https://www.unisport.fi/oulu/',
    ),
  ];

  static const _national = [
    _Item(
      icon: Icons.flag_outlined,
      title: 'SELL Games – Nordic Student Championships',
      description:
          'SELL Games is an annual multi-sport competition between Nordic universities. University of Oulu students can apply for the travelling team through UniSport.',
      url: 'https://www.sellgames.fi/',
    ),
    _Item(
      icon: Icons.public_outlined,
      title: 'Finnish University Sports (OLL)',
      description:
          'OLL (Opiskelijan liikuntaliitto) coordinates national student sports championships in Finland. Browse the schedule to find competitions in your sport.',
      url: 'https://www.oll.fi/',
    ),
    _Item(
      icon: Icons.calendar_month_outlined,
      title: 'Sports Event Calendar',
      description:
          'The university\'s general event calendar also lists upcoming student sports events, tournaments, and sign-up deadlines happening on and off campus.',
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
