import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WellnessMindfulnessPage extends StatelessWidget {
  const WellnessMindfulnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Wellness & Mindfulness'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Mindfulness & Yoga'),
            const SizedBox(height: 12),
            ..._mindfulness.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Stress Relief & Recovery'),
            const SizedBox(height: 12),
            ..._recovery.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.self_improvement_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wellness & Mindfulness',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Recharge your body and mind with yoga, meditation, and wellness resources.',
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

  static const _mindfulness = [
    _Item(
      icon: Icons.self_improvement_outlined,
      title: 'UniSport Yoga Classes',
      description:
          'UniSport Oulu runs weekly yoga sessions at the campus sports facility. Suitable for all levels — no experience required. Book your spot through the UniSport website.',
      url: 'https://www.unisport.fi/oulu/ryhmaliikunta/',
    ),
    _Item(
      icon: Icons.spa_outlined,
      title: 'Meditation & Mindfulness Sessions',
      description:
          'UniSport and student wellbeing services occasionally organise guided mindfulness sessions. These are especially popular during exam periods.',
      url: 'https://www.unisport.fi/oulu/',
    ),
    _Item(
      icon: Icons.phone_android_outlined,
      title: 'Calm – Meditation App',
      description:
          'The Calm app offers guided meditations, sleep stories, and breathing exercises. Many university students use it to manage stress and improve sleep quality.',
      url: 'https://www.calm.com/',
    ),
  ];

  static const _recovery = [
    _Item(
      icon: Icons.hot_tub_outlined,
      title: 'Sauna Culture',
      description:
          'Sauna is an essential part of Finnish student life and an excellent recovery tool. Many guilds, including Tietokilta, organise sauna evenings for members.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.bedtime_outlined,
      title: 'Sleep & Recovery Tips',
      description:
          'The FSHS student health service provides guidance on improving sleep habits and managing fatigue during intensive study periods.',
      url: 'https://www.yths.fi/en/services/mental-health/',
    ),
    _Item(
      icon: Icons.local_hospital_outlined,
      title: 'FSHS – Student Wellbeing',
      description:
          'FSHS offers comprehensive support for students including psychological counselling, stress management resources, and health check-ups.',
      url: 'https://www.yths.fi/en/',
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
