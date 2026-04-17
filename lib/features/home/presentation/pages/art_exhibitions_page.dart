import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtExhibitionsPage extends StatelessWidget {
  const ArtExhibitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Art Exhibitions'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Campus Art Spaces'),
            const SizedBox(height: 12),
            ..._campus.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'City Galleries & Museums'),
            const SizedBox(height: 12),
            ..._city.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.brush_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Art Exhibitions',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Discover student art and explore cultural exhibitions on campus and across Oulu.',
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

  static const _campus = [
    _Item(
      icon: Icons.business_outlined,
      title: 'Tellus Innovation Arena',
      description:
          'Tellus regularly hosts student art exhibitions, design showcases, and creative projects. A great space to exhibit your own work or discover fellow student artists.',
      url: 'https://www.oulu.fi/en/university/campuses-and-services/tellus-innovation-arena',
    ),
    _Item(
      icon: Icons.photo_outlined,
      title: 'Campus Corridor Exhibitions',
      description:
          'Student artwork is often displayed in the corridors and common areas of the Linnanmaa campus buildings. Keep an eye out for new installations throughout the year.',
      url: 'https://www.oulu.fi/en/events',
    ),
    _Item(
      icon: Icons.palette_outlined,
      title: 'Student Art Shows',
      description:
          'End-of-year and semester student art shows are organised by guilds and the Student Union. These open exhibitions are free to attend and a great way to support peers.',
      url: 'https://www.svy.fi/',
    ),
  ];

  static const _city = [
    _Item(
      icon: Icons.museum_outlined,
      title: 'Oulu Art Museum (OKT)',
      description:
          'The Oulu Art Museum hosts rotating contemporary art exhibitions. Student entry is discounted with the Frank card — a recommended cultural visit for all IPS students.',
      url: 'https://www.ouka.fi/oulu/taidemuseo',
    ),
    _Item(
      icon: Icons.photo_library_outlined,
      title: 'Pohjoinen Valokuvakeskus – Photo Centre',
      description:
          'The Northern Photographic Centre in Oulu city centre showcases Finnish and international photography exhibitions. Free or low-cost entry for students.',
      url: 'https://www.pvk.fi/',
    ),
    _Item(
      icon: Icons.history_outlined,
      title: 'Oulu Museum of History',
      description:
          'Learn about the cultural and natural history of Northern Finland. The museum offers student discounts and occasional free entry days.',
      url: 'https://www.ouka.fi/oulu/museo',
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
