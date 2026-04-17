import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RunningOutdoorPage extends StatelessWidget {
  const RunningOutdoorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Running & Outdoor Activities'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Running & Cycling'),
            const SizedBox(height: 12),
            ..._running.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Outdoor Adventures'),
            const SizedBox(height: 12),
            ..._outdoor.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.directions_run_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Running & Outdoor Activities',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Explore Oulu\'s excellent outdoor routes and nature activities year-round.',
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

  static const _running = [
    _Item(
      icon: Icons.directions_run_outlined,
      title: 'Oulujoki Riverside Trail',
      description:
          'A 5 km scenic running and cycling path along the Oulujoki river, right next to campus. Flat terrain and beautiful scenery make it ideal for all fitness levels.',
      url: 'https://www.oulu.fi/en/life-in-oulu/sports-and-nature',
    ),
    _Item(
      icon: Icons.pedal_bike_outlined,
      title: 'Cycling in Oulu',
      description:
          'Oulu is one of the most cycling-friendly cities in Europe, with an extensive network of dedicated bike lanes. Renting or buying a bike is highly recommended.',
      url: 'https://www.oulu.fi/en/life-in-oulu/transport/cycling',
    ),
    _Item(
      icon: Icons.phone_android_outlined,
      title: 'Strava – Track Your Routes',
      description:
          'Use Strava to log your runs and rides, discover popular local routes around Oulu, and join student running segments and challenges.',
      url: 'https://www.strava.com/',
    ),
  ];

  static const _outdoor = [
    _Item(
      icon: Icons.terrain_outlined,
      title: 'Hupisaaret City Park',
      description:
          'A beautiful riverside park close to the city centre, perfect for leisurely walks, picnics, and light jogging. Easily reachable by bike from Linnanmaa campus.',
      url: 'https://www.oulu.fi/en/life-in-oulu/sports-and-nature/parks',
    ),
    _Item(
      icon: Icons.ac_unit_outlined,
      title: 'Winter Outdoor Activities',
      description:
          'In winter, Oulu transforms into a playground for skiing, snowshoeing, and ice-skating. Frozen rivers and nearby trails make outdoor winter sports very accessible.',
      url: 'https://www.oulu.fi/en/life-in-oulu/sports-and-nature',
    ),
    _Item(
      icon: Icons.nature_people_outlined,
      title: 'National Parks Near Oulu',
      description:
          'Oulanka National Park and Rokua Geopark are within driving distance of Oulu. Both offer stunning nature experiences popular with students for weekend trips.',
      url: 'https://www.nationalparks.fi/oulanka',
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
