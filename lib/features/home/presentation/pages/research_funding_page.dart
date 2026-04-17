import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResearchFundingPage extends StatelessWidget {
  const ResearchFundingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Research Funding'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Finnish Funding Sources'),
            const SizedBox(height: 12),
            ..._finnish.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'European & International Grants'),
            const SizedBox(height: 12),
            ..._international.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.monetization_on_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Research Funding',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Find grants and funding opportunities for your research from Finnish and EU sources.',
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

  static const _finnish = [
    _Item(
      icon: Icons.flag_outlined,
      title: 'Academy of Finland',
      description:
          'The Academy of Finland is the main public funder of scientific research in Finland. They offer project grants, research fellowships, and doctoral programme funding.',
      url: 'https://www.aka.fi/en/',
    ),
    _Item(
      icon: Icons.business_outlined,
      title: 'Business Finland',
      description:
          'Business Finland funds innovation, internationalisation, and R&D activities. Student researchers and startup founders can apply for proof-of-concept and young innovator grants.',
      url: 'https://www.businessfinland.fi/en/for-finnish-customers/services/funding',
    ),
    _Item(
      icon: Icons.account_balance_outlined,
      title: 'University Research Grants',
      description:
          'The University of Oulu offers internal research grants and travel grants for student researchers. Check the faculty research office for current calls and eligibility.',
      url: 'https://www.oulu.fi/en/research/funding',
    ),
  ];

  static const _international = [
    _Item(
      icon: Icons.public_outlined,
      title: 'EU Horizon Europe',
      description:
          'Horizon Europe is the EU\'s flagship research funding programme with a budget of nearly €100 billion. Student researchers can participate through their supervisor\'s projects.',
      url: 'https://research-and-innovation.ec.europa.eu/funding/funding-opportunities/funding-programmes-and-open-calls/horizon-europe_en',
    ),
    _Item(
      icon: Icons.flight_outlined,
      title: 'Marie Skłodowska-Curie Actions',
      description:
          'MSCA fellowships and doctoral networks fund individual researchers and collaborative training programmes. A highly prestigious route for PhD and postdoc researchers.',
      url: 'https://marie-sklodowska-curie-actions.ec.europa.eu/',
    ),
    _Item(
      icon: Icons.groups_outlined,
      title: 'Research Office Support',
      description:
          'The university\'s Research and Innovation Services office helps researchers identify funding sources, prepare applications, and manage grants. Contact them for guidance.',
      url: 'https://www.oulu.fi/en/research/funding',
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
