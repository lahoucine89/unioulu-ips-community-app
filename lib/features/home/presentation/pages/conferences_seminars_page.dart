import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConferencesSeminarsPage extends StatelessWidget {
  const ConferencesSeminarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Conferences & Seminars'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Key Conferences in IPS Fields'),
            const SizedBox(height: 12),
            ..._conferences.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Travel Grants & Seminars'),
            const SizedBox(height: 12),
            ..._grants.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.event_note_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conferences & Seminars',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Present your research and engage with the global academic community.',
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

  static const _conferences = [
    _Item(
      icon: Icons.touch_app_outlined,
      title: 'CHI – Conference on Human Factors',
      description:
          'CHI is the premier conference in HCI and interactive systems — a top venue for INTERACT research group publications. Student volunteers and travel grants are available.',
      url: 'https://chi.acm.org/',
    ),
    _Item(
      icon: Icons.wifi_outlined,
      title: 'IEEE VTC & ICC – Communications',
      description:
          'Leading IEEE conferences on vehicular technology and communications, directly relevant to CWC research group work. Key publication venues for IPS students in wireless.',
      url: 'https://ieeexplore.ieee.org/',
    ),
    _Item(
      icon: Icons.computer_outlined,
      title: 'ISWC & Ubicomp – Wearables & IoT',
      description:
          'ISWC (International Symposium on Wearable Computers) and Ubicomp are top venues for pervasive computing research, an active area at IPS.',
      url: 'https://www.ubicomp.org/',
    ),
    _Item(
      icon: Icons.search_outlined,
      title: 'WikiCFP – Find Conferences',
      description:
          'WikiCFP lists call-for-papers from thousands of academic conferences. Search by keyword to find relevant venues for your research area and submission deadlines.',
      url: 'http://www.wikicfp.com/',
    ),
  ];

  static const _grants = [
    _Item(
      icon: Icons.flight_outlined,
      title: 'University Travel Grants',
      description:
          'The University of Oulu offers travel grants for student researchers presenting papers at international conferences. Apply through the faculty research office.',
      url: 'https://www.oulu.fi/en/research/funding',
    ),
    _Item(
      icon: Icons.people_alt_outlined,
      title: 'Student Volunteer Programmes',
      description:
          'Many major conferences offer student volunteer positions that give you free or discounted registration in exchange for a few hours of work. A great way to attend affordably.',
      url: 'https://chi.acm.org/',
    ),
    _Item(
      icon: Icons.event_outlined,
      title: 'IPS Seminar Series',
      description:
          'The IPS faculty hosts a regular seminar series with invited speakers from academia and industry. Attending keeps you up to date with the latest research trends.',
      url: 'https://www.oulu.fi/en/events',
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
