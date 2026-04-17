import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicationsJournalsPage extends StatelessWidget {
  const PublicationsJournalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Publications & Journals'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'IPS Publications & Repositories'),
            const SizedBox(height: 12),
            ..._repositories.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Academic Search Engines'),
            const SizedBox(height: 12),
            ..._search.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.article_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Publications & Journals',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Access IPS research publications and explore major academic journals and databases.',
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

  static const _repositories = [
    _Item(
      icon: Icons.school_outlined,
      title: 'Jultika – University Repository',
      description:
          'Jultika is the open-access publication archive of the University of Oulu. Find dissertations, theses, conference papers, and research articles from IPS researchers.',
      url: 'http://jultika.oulu.fi/',
    ),
    _Item(
      icon: Icons.public_outlined,
      title: 'Google Scholar – Faculty Profiles',
      description:
          'Follow IPS faculty researchers on Google Scholar to stay updated on their latest publications and citation counts in your research area.',
      url: 'https://scholar.google.com/',
    ),
    _Item(
      icon: Icons.connect_without_contact_outlined,
      title: 'ResearchGate',
      description:
          'ResearchGate allows you to follow researchers, read preprints, and connect with academics worldwide. Many IPS faculty have active profiles sharing their work.',
      url: 'https://www.researchgate.net/',
    ),
  ];

  static const _search = [
    _Item(
      icon: Icons.search_outlined,
      title: 'Scopus',
      description:
          'Scopus is the world\'s largest abstract and citation database for peer-reviewed literature. Access via the university network or VPN using your university credentials.',
      url: 'https://www.scopus.com/',
    ),
    _Item(
      icon: Icons.article_outlined,
      title: 'Web of Science',
      description:
          'Web of Science provides multidisciplinary access to millions of peer-reviewed articles. University of Oulu students have full institutional access.',
      url: 'https://www.webofscience.com/',
    ),
    _Item(
      icon: Icons.biotech_outlined,
      title: 'IEEE Xplore',
      description:
          'Full-text access to IEEE journals, conference proceedings, and standards — essential for engineering, electronics, and computer science research at IPS.',
      url: 'https://ieeexplore.ieee.org/',
    ),
    _Item(
      icon: Icons.computer_outlined,
      title: 'ACM Digital Library',
      description:
          'The ACM Digital Library contains the full collection of ACM publications — the primary venue for computing and HCI research relevant to many IPS research groups.',
      url: 'https://dl.acm.org/',
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
