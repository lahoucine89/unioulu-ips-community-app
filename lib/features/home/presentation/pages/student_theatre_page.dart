import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentTheatrePage extends StatelessWidget {
  const StudentTheatrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Theatre'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Theatre Groups'),
            const SizedBox(height: 12),
            ..._groups.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Events & Productions'),
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
            child: Icon(Icons.theater_comedy_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Theatre',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Perform, direct, or simply enjoy student theatre productions at the University of Oulu.',
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

  static const _groups = [
    _Item(
      icon: Icons.theater_comedy_outlined,
      title: 'Oulun Ylioppilasteatteriyhdistys',
      description:
          'The official student theatre association at the University of Oulu. They put on multiple productions per year and welcome new actors, directors, and crew members.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.groups_outlined,
      title: 'Improv & Comedy Groups',
      description:
          'Student improv comedy groups are active in Oulu. Performances are typically held in campus spaces — casual, fun, and always looking for new performers.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.how_to_reg_outlined,
      title: 'Auditions & Joining',
      description:
          'Auditions for university theatre productions are open to all students — no previous experience needed. Watch the SYY and university event channels for announcements.',
      url: 'https://www.svy.fi/',
    ),
  ];

  static const _events = [
    _Item(
      icon: Icons.event_seat_outlined,
      title: 'University Event Calendar',
      description:
          'Check the university event calendar for upcoming student theatre shows, ticket releases, and cultural events happening at Linnanmaa and around Oulu.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.location_city_outlined,
      title: 'Oulu City Theatre',
      description:
          'The professional Oulu City Theatre (Oulun Kaupunginteatteri) offers student discounts on tickets. A great way to experience high-quality Finnish and international theatre.',
      url: 'https://www.oulunkaupunginteatteri.fi/',
    ),
    _Item(
      icon: Icons.movie_outlined,
      title: 'Student Film & Media',
      description:
          'Beyond stage theatre, student film clubs and media production groups are active at the university. Keep an eye on guild and SYY channels for project announcements.',
      url: 'https://www.svy.fi/',
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
