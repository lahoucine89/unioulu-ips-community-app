import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicGroupsPage extends StatelessWidget {
  const MusicGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Music Groups'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Student Music Groups'),
            const SizedBox(height: 12),
            ..._groups.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Concerts & Events'),
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
            child: Icon(Icons.music_note_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Music Groups',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Join a student music group or enjoy live concerts and performances on campus.',
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
      icon: Icons.queue_music_outlined,
      title: 'University Choir',
      description:
          'The University of Oulu choir welcomes singers of all levels. Rehearsals are held weekly and the choir performs several concerts each academic year.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.piano_outlined,
      title: 'Jazz & Big Band Ensemble',
      description:
          'The university jazz ensemble and big band perform regularly on campus. New members are recruited at the start of each semester — no formal audition required.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.music_video_outlined,
      title: 'Student Bands & Jam Sessions',
      description:
          'Various student bands form through guild networks and social media. The Tellus Innovation Arena hosts informal jam sessions and small gigs throughout the year.',
      url: 'https://www.oulu.fi/en/university/campuses-and-services/tellus-innovation-arena',
    ),
    _Item(
      icon: Icons.how_to_reg_outlined,
      title: 'Join a Music Group',
      description:
          'Contact the Student Union (SYY) or check the university event board to find current music groups looking for members. All instruments and voice types are welcome.',
      url: 'https://www.svy.fi/',
    ),
  ];

  static const _events = [
    _Item(
      icon: Icons.event_outlined,
      title: 'University Event Calendar',
      description:
          'The university event calendar lists all upcoming student concerts, choir performances, and music events happening at Linnanmaa and the city centre venues.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.location_city_outlined,
      title: 'Oulu Music Centre',
      description:
          'The Oulu Music Centre (Musiikkikeskus) hosts the Oulu Symphony Orchestra and visiting artists. Student tickets are available at a significant discount.',
      url: 'https://www.oulunmusiikkikeskus.fi/',
    ),
    _Item(
      icon: Icons.festival_outlined,
      title: 'Oulu Music Festivals',
      description:
          'Oulu hosts several music festivals throughout the year including Qstock and Oulu Music Festival. Student discounts are often available for tickets.',
      url: 'https://www.qstock.fi/',
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
