import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResearchGroupsPage extends StatelessWidget {
  const ResearchGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Research Groups'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'IPS Research Groups'),
            const SizedBox(height: 12),
            ..._groups.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Get Involved'),
            const SizedBox(height: 12),
            ..._involved.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.groups_2_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Research Groups',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Explore world-class research groups at IPS and find collaboration opportunities.',
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

  static const _groups = [
    _Item(
      icon: Icons.touch_app_outlined,
      title: 'INTERACT – Human-Computer Interaction',
      description:
          'INTERACT is a leading HCI research unit at IPS focused on user experience, accessibility, and interactive systems. One of the most internationally recognised groups at Oulu.',
      url: 'https://interact.oulu.fi/',
    ),
    _Item(
      icon: Icons.wifi_outlined,
      title: 'CWC – Centre for Wireless Communications',
      description:
          'CWC is a world-leading wireless communications research centre. Research covers 5G/6G, antenna systems, and signal processing — core areas for IPS students.',
      url: 'https://www.oulu.fi/en/research/units/centre-wireless-communications',
    ),
    _Item(
      icon: Icons.biotech_outlined,
      title: 'BISG – Biocenter Oulu',
      description:
          'Biocenter Oulu conducts cutting-edge biomedical research. Interdisciplinary projects connect with information technology and AI for healthcare applications.',
      url: 'https://www.biocenter.oulu.fi/',
    ),
    _Item(
      icon: Icons.science_outlined,
      title: 'All IPS Research Units',
      description:
          'Browse the full list of research groups and units within the Faculty of Information Technology and Electrical Engineering on the university research portal.',
      url: 'https://www.oulu.fi/en/research/units',
    ),
  ];

  static const _involved = [
    _Item(
      icon: Icons.work_history_outlined,
      title: 'Research Assistant Positions',
      description:
          'RA positions are posted on the faculty website, Tietokilta job board, and through direct contact with group supervisors. Email the group leader with your CV and interests.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.school_outlined,
      title: 'Thesis in a Research Group',
      description:
          'Many IPS students write their master\'s thesis within a research group. Contact faculty staff whose research aligns with your interests to discuss thesis supervision.',
      url: 'https://www.oulu.fi/en/for-students/studying/thesis',
    ),
    _Item(
      icon: Icons.article_outlined,
      title: 'Research Portal – Oulu',
      description:
          'The university research portal provides an overview of all ongoing research projects, publications, and researcher profiles at the University of Oulu.',
      url: 'https://research.oulu.fi/',
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
