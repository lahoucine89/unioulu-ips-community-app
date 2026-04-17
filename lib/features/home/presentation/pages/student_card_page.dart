import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCardPage extends StatelessWidget {
  const StudentCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Card (Frank)'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Activate Your Card'),
            const SizedBox(height: 12),
            ..._activation.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Discounts & Benefits'),
            const SizedBox(height: 12),
            ..._benefits.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.card_membership_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Card (Frank)',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Unlock discounts on transport, food, culture, and shopping across Finland.',
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

  static const _activation = [
    _Item(
      icon: Icons.phone_android_outlined,
      title: 'Frank App – Digital Student Card',
      description:
          'Download the Frank app to get your digital student card. It works as proof of student status and gives you access to hundreds of discounts across Finland.',
      url: 'https://www.frank.fi/',
    ),
    _Item(
      icon: Icons.credit_card_outlined,
      title: 'Physical Student Card (ISIC)',
      description:
          'You can also order a physical ISIC-certified student card through Frank. It is valid internationally and recognised by shops, museums, and transport providers.',
      url: 'https://www.frank.fi/',
    ),
    _Item(
      icon: Icons.how_to_reg_outlined,
      title: 'Eligibility & Registration',
      description:
          'To activate Frank, you need to confirm your student status. Make sure you are registered for the current academic year at the University of Oulu.',
      url: 'https://www.oulu.fi/en/for-students/new-students/registration',
    ),
  ];

  static const _benefits = [
    _Item(
      icon: Icons.directions_bus_outlined,
      title: 'VR Trains – 50% Discount',
      description:
          'Get 50% off train tickets with your Frank student card across Finland. Show the app or physical card when buying tickets at VR stations or online.',
      url: 'https://www.vr.fi/en/student-discount',
    ),
    _Item(
      icon: Icons.local_movies_outlined,
      title: 'Culture & Entertainment',
      description:
          'Frank gives you discounts at cinemas, theatres, museums, and cultural events across Finland. Check the Frank app\'s offer feed for current deals near Oulu.',
      url: 'https://www.frank.fi/',
    ),
    _Item(
      icon: Icons.restaurant_outlined,
      title: 'Kela Meal Subsidy',
      description:
          'Present your student card at approved campus restaurants to get the Kela-subsidised student meal for approximately €2.95 — one of the best student perks in Finland.',
      url: 'https://www.kela.fi/meal-subsidy',
    ),
    _Item(
      icon: Icons.shopping_bag_outlined,
      title: 'Shop & Service Discounts',
      description:
          'Hundreds of Finnish businesses offer student discounts through Frank — including gyms, tech stores, software subscriptions, and clothing retailers.',
      url: 'https://www.frank.fi/',
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
