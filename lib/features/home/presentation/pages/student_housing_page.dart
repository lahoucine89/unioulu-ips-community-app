import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHousingPage extends StatelessWidget {
  const StudentHousingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Housing'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Housing Providers'),
            const SizedBox(height: 12),
            ..._providers.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Practical Information'),
            const SizedBox(height: 12),
            ..._practical.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.home_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Housing',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Find affordable student accommodation in Oulu for your studies.',
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

  static const _providers = [
    _Item(
      icon: Icons.apartment_outlined,
      title: 'PSOAS – Student Housing Foundation',
      description:
          'PSOAS is the main student housing provider in Oulu, offering affordable apartments close to campus. Apply online — spots fill up fast at the start of the academic year.',
      url: 'https://www.psoas.fi/',
    ),
    _Item(
      icon: Icons.account_balance_outlined,
      title: 'SYY Housing',
      description:
          'The Student Union of the University of Oulu (SYY) also offers housing options and can guide you through the application process for student apartments.',
      url: 'https://www.svy.fi/',
    ),
    _Item(
      icon: Icons.search_outlined,
      title: 'Vuokraovi – Private Rentals',
      description:
          'Browse private rental listings in Oulu. A good option if student housing is full — filter by area and price to find something near the Linnanmaa campus.',
      url: 'https://www.vuokraovi.com/vuokra-asunnot/oulu',
    ),
    _Item(
      icon: Icons.location_city_outlined,
      title: 'Oikotie – Housing Listings',
      description:
          'Another popular Finnish rental platform with a wide range of apartments in Oulu. Listings are updated daily with both furnished and unfurnished options.',
      url: 'https://asunnot.oikotie.fi/vuokra-asunnot/oulu',
    ),
  ];

  static const _practical = [
    _Item(
      icon: Icons.bolt_outlined,
      title: 'Electricity – Caruna & Others',
      description:
          'You\'ll need to set up an electricity contract when moving in. Caruna handles distribution in Oulu. Compare suppliers on the Energiavirasto price comparison tool.',
      url: 'https://www.sahkonhinta.fi/',
    ),
    _Item(
      icon: Icons.wifi_outlined,
      title: 'Internet Connection',
      description:
          'Most PSOAS apartments include internet or allow installation of broadband. DNA, Elisa, and Telia are the main providers with good coverage in Oulu.',
      url: 'https://www.dna.fi/en/internet',
    ),
    _Item(
      icon: Icons.info_outline,
      title: 'International Student Guide',
      description:
          'The University of Oulu\'s guide for international students covers housing tips, moving to Finland, and what to expect when settling in Oulu.',
      url: 'https://www.oulu.fi/en/for-students/international-students',
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
