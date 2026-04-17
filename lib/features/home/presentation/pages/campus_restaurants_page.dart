import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusRestaurantsPage extends StatelessWidget {
  const CampusRestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Campus Restaurants'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Campus Eateries'),
            const SizedBox(height: 12),
            ..._eateries.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Discounts & Cards'),
            const SizedBox(height: 12),
            ..._discounts.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.restaurant_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Campus Restaurants',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Enjoy subsidised student meals at campus cafeterias and restaurants.',
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

  static const _eateries = [
    _Item(
      icon: Icons.restaurant_outlined,
      title: 'Kerttu – Main Campus Restaurant',
      description:
          'The largest cafeteria on Linnanmaa campus. Offers a daily hot lunch, salad bar, and vegetarian options. Open on weekdays with lunch served 10:30–13:30.',
      url: 'https://www.compass-group.fi/ravintolat/opiskelijaravintolat/oulu/linnanmaa/',
    ),
    _Item(
      icon: Icons.local_cafe_outlined,
      title: 'Kastari – Campus Café',
      description:
          'A smaller café on campus ideal for a quick coffee, sandwich, or pastry between lectures. Also serves a daily lunch menu at student prices.',
      url: 'https://www.compass-group.fi/ravintolat/opiskelijaravintolat/oulu/',
    ),
    _Item(
      icon: Icons.store_outlined,
      title: 'Tellus Café',
      description:
          'Located in the Tellus Innovation Arena, this café is popular for group work sessions and informal meetings. Offers hot drinks, snacks, and light meals.',
      url: 'https://www.oulu.fi/en/university/campuses-and-services/tellus-innovation-arena',
    ),
    _Item(
      icon: Icons.soup_kitchen_outlined,
      title: 'Fazer Food Services',
      description:
          'Fazer operates several food points across the Oulu campus. Check the Fazer app for daily menus, locations, and opening hours updated each week.',
      url: 'https://www.fazerfoodservices.fi/',
    ),
  ];

  static const _discounts = [
    _Item(
      icon: Icons.card_membership_outlined,
      title: 'Kela Meal Subsidy',
      description:
          'Finnish Social Insurance Institution (Kela) subsidises student meals at approved campus restaurants. Present your student card to get meals at the discounted price (~2.95 €).',
      url: 'https://www.kela.fi/meal-subsidy',
    ),
    _Item(
      icon: Icons.phone_android_outlined,
      title: 'Frank App – Student Discounts',
      description:
          'Use the Frank app as your digital student card to access meal subsidies and other discounts. Available on iOS and Android for all Finnish university students.',
      url: 'https://www.frank.fi/',
    ),
    _Item(
      icon: Icons.eco_outlined,
      title: 'Vegetarian & Special Diets',
      description:
          'All campus restaurants offer vegetarian and vegan options daily. Inform staff of allergies or special dietary needs — they are happy to accommodate.',
      url: 'https://www.compass-group.fi/ravintolat/opiskelijaravintolat/oulu/',
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
