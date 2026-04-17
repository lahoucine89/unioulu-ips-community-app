import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EntrepreneurshipPage extends StatelessWidget {
  const EntrepreneurshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Entrepreneurship'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Startup Support'),
            const SizedBox(height: 12),
            ..._startup.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Funding & Competitions'),
            const SizedBox(height: 12),
            ..._funding.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Entrepreneurship',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Turn your ideas into a business with startup support, mentoring, and funding in Oulu.',
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

  static const _startup = [
    _Item(
      icon: Icons.business_outlined,
      title: 'BusinessOulu',
      description:
          'BusinessOulu is the city\'s official business development agency. They offer free startup advisory, co-working spaces, and connections to the Oulu startup ecosystem.',
      url: 'https://www.businessoulu.com/',
    ),
    _Item(
      icon: Icons.hub_outlined,
      title: 'Oulu Innovation Alliance',
      description:
          'The Oulu Innovation Alliance connects the university, city, and businesses to create opportunities for student entrepreneurs and innovators in Northern Finland.',
      url: 'https://www.ouluinnovationalliance.fi/',
    ),
    _Item(
      icon: Icons.school_outlined,
      title: 'Kerttu Saalasti Institute',
      description:
          'The university\'s institute for entrepreneurship and small business research supports student startups with mentoring, research, and incubation programmes.',
      url: 'https://www.oulu.fi/en/university/faculties-and-units/kerttu-saalasti-institute',
    ),
    _Item(
      icon: Icons.business_center_outlined,
      title: 'Oulu Startup Hub',
      description:
          'The Oulu Startup Hub provides co-working space, events, and a community of entrepreneurs. Students can use the space to work on their startup ideas alongside local founders.',
      url: 'https://www.businessoulu.com/',
    ),
  ];

  static const _funding = [
    _Item(
      icon: Icons.monetization_on_outlined,
      title: 'Business Finland – Startup Grants',
      description:
          'Business Finland offers innovation grants and funding for early-stage startups. Students can apply individually or as part of a team for proof-of-concept funding.',
      url: 'https://www.businessfinland.fi/en/for-finnish-customers/services/funding/startups',
    ),
    _Item(
      icon: Icons.emoji_events_outlined,
      title: 'Startup Competitions',
      description:
          'Several national startup competitions are open to student teams each year, including Slush 100, Arctic15, and university-level innovation challenges with cash prizes.',
      url: 'https://www.slush.org/',
    ),
    _Item(
      icon: Icons.euro_outlined,
      title: 'EU Horizon – Innovation Funding',
      description:
          'EU Horizon Europe funds innovative research and startup projects from university teams. The university\'s research services office can help you identify relevant calls.',
      url: 'https://research-and-innovation.ec.europa.eu/funding/funding-opportunities/funding-programmes-and-open-calls/horizon-europe_en',
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
