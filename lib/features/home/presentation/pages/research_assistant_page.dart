import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResearchAssistantPage extends StatelessWidget {
  const ResearchAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Research Assistant Positions'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Find RA Positions'),
            const SizedBox(height: 12),
            ..._find.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'What to Expect'),
            const SizedBox(height: 12),
            ..._expect.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.work_history_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Research Assistant Positions',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Join an IPS research lab as a research assistant and gain hands-on research experience.',
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

  static const _find = [
    _Item(
      icon: Icons.work_outlined,
      title: 'Faculty Website – Open Positions',
      description:
          'The Faculty of Information Technology and Electrical Engineering lists open RA positions on its website. Check regularly as new positions are posted throughout the year.',
      url: 'https://www.oulu.fi/en/university/faculties-and-units/faculty-information-technology-and-electrical-engineering',
    ),
    _Item(
      icon: Icons.computer_outlined,
      title: 'Tietokilta Job Board',
      description:
          'The IPS student guild Tietokilta regularly posts research assistant and thesis worker positions from IPS research groups and affiliated companies.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.email_outlined,
      title: 'Contact Research Groups Directly',
      description:
          'Many RA positions are filled through direct contact. Email research group leaders with your CV, academic transcripts, and a brief explanation of your research interests.',
      url: 'https://research.oulu.fi/',
    ),
    _Item(
      icon: Icons.work_history_outlined,
      title: 'University Career Portal',
      description:
          'The university career portal also lists student research positions, including part-time RA roles, summer researchers, and project-based student employees.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
  ];

  static const _expect = [
    _Item(
      icon: Icons.euro_outlined,
      title: 'Salary & Working Hours',
      description:
          'RA positions at Finnish universities are typically paid at the university\'s student salary scale (around €10–15/hour). Part-time roles of 10–20 hours per week are common.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.science_outlined,
      title: 'Typical RA Tasks',
      description:
          'Tasks vary by group but often include literature reviews, data collection, programming experiments, lab work, and helping with paper writing. A great learning experience.',
      url: 'https://research.oulu.fi/',
    ),
    _Item(
      icon: Icons.school_outlined,
      title: 'RA as a Path to a Thesis',
      description:
          'Working as an RA often leads naturally to a thesis topic within the same research group. It\'s one of the most reliable routes to a well-supervised master\'s thesis.',
      url: 'https://www.oulu.fi/en/for-students/studying/thesis',
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
