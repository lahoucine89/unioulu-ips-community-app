import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UnisportFacilitiesPage extends StatelessWidget {
  const UnisportFacilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'UniSport Facilities'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Facilities & Memberships'),
            const SizedBox(height: 12),
            ..._facilities.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Classes & Activities'),
            const SizedBox(height: 12),
            ..._classes.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.fitness_center_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UniSport Facilities',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Gyms, pools, group classes, and sports halls available to all University of Oulu students.',
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

  static const _facilities = [
    _Item(
      icon: Icons.fitness_center_outlined,
      title: 'UniSport Oulu – Overview',
      description:
          'UniSport Oulu operates sports facilities across campus including gyms, sports halls, a swimming pool, and outdoor areas. A semester pass is available at student price.',
      url: 'https://www.unisport.fi/oulu/',
    ),
    _Item(
      icon: Icons.card_membership_outlined,
      title: 'Sports Pass & Pricing',
      description:
          'Buy a seasonal or annual UniSport pass to access all facilities. The student price is significantly subsidised — check the current pricing on the UniSport website.',
      url: 'https://www.unisport.fi/oulu/hinnasto/',
    ),
    _Item(
      icon: Icons.pool_outlined,
      title: 'Swimming Pool',
      description:
          'The campus swimming pool is open year-round for lap swimming, recreational swimming, and water aerobics classes. Check the schedule for open swim sessions.',
      url: 'https://www.unisport.fi/oulu/uimahalli/',
    ),
    _Item(
      icon: Icons.sports_volleyball_outlined,
      title: 'Sports Halls & Courts',
      description:
          'Book badminton, squash, and basketball courts through the UniSport reservation system. Halls are also available for student clubs and group training sessions.',
      url: 'https://www.unisport.fi/oulu/vuorot/',
    ),
  ];

  static const _classes = [
    _Item(
      icon: Icons.event_note_outlined,
      title: 'Group Fitness Schedule',
      description:
          'UniSport runs group fitness classes including yoga, spinning, circuit training, and Zumba throughout the week. Book your spot online in advance.',
      url: 'https://www.unisport.fi/oulu/ryhmaliikunta/',
    ),
    _Item(
      icon: Icons.self_improvement_outlined,
      title: 'Yoga & Mindfulness',
      description:
          'Weekly yoga and mindfulness sessions are available at student-friendly times. Great for managing exam stress and improving focus and flexibility.',
      url: 'https://www.unisport.fi/oulu/ryhmaliikunta/',
    ),
    _Item(
      icon: Icons.sports_gymnastics_outlined,
      title: 'Personal Training',
      description:
          'UniSport offers personal training packages with certified trainers. Ideal if you want to build a structured workout programme or achieve a specific fitness goal.',
      url: 'https://www.unisport.fi/oulu/',
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
