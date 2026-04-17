import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InternationalEventsPage extends StatelessWidget {
  const InternationalEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'International Student Events'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'International Communities'),
            const SizedBox(height: 12),
            ..._communities.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Exchange & Cultural Events'),
            const SizedBox(height: 12),
            ..._events.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.public_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('International Student Events',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Connect with international students and celebrate global diversity at IPS.',
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

  static const _communities = [
    _Item(
      icon: Icons.flight_outlined,
      title: 'ESN Oulu – Erasmus Student Network',
      description:
          'ESN Oulu is the main community for international and exchange students. They organise cultural nights, excursions, buddy programmes, and social events year-round.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.language_outlined,
      title: 'International Office',
      description:
          'The University of Oulu\'s International Office supports incoming and outgoing exchange students with guidance on visas, study arrangements, and cultural adaptation.',
      url: 'https://www.oulu.fi/en/for-students/international-students',
    ),
    _Item(
      icon: Icons.groups_outlined,
      title: 'IPS Student Community',
      description:
          'The IPS student community is itself highly international. Connect with fellow IPS students through Tietokilta events, the IPS Discord, and faculty-organised meetups.',
      url: 'https://tietokilta.fi/',
    ),
  ];

  static const _events = [
    _Item(
      icon: Icons.dinner_dining_outlined,
      title: 'International Dinner Nights',
      description:
          'ESN Oulu regularly hosts international dinner events where students share food and culture from their home countries. A great way to try new cuisines and meet people.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.translate_outlined,
      title: 'Language Café',
      description:
          'Weekly language café sessions bring together students who want to practise different languages in a relaxed, informal setting. All languages and levels welcome.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.map_outlined,
      title: 'Finland Excursions & Trips',
      description:
          'ESN Oulu organises trips around Finland — Lapland, Rovaniemi, Helsinki, and more. An excellent way to explore the country and build friendships with other students.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.event_outlined,
      title: 'University Event Calendar',
      description:
          'Stay updated on all international student events, cultural festivals, and community meetups through the official university events page.',
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
