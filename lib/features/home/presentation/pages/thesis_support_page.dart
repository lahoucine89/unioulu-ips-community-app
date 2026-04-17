import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ThesisSupportPage extends StatelessWidget {
  const ThesisSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Thesis Support'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Getting Started'),
            const SizedBox(height: 12),
            ..._start.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Writing & Research Tools'),
            const SizedBox(height: 12),
            ..._tools.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.school_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thesis Support',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Resources and guidance for writing your bachelor\'s or master\'s thesis at IPS.',
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

  static const _start = [
    _Item(
      icon: Icons.info_outline,
      title: 'Thesis Guidelines – IPS',
      description:
          'Read the official thesis guidelines for your IPS programme, covering structure, formatting, submission process, and grading criteria.',
      url: 'https://www.oulu.fi/en/for-students/studying/thesis',
    ),
    _Item(
      icon: Icons.people_outline,
      title: 'Thesis Seminars',
      description:
          'The faculty organises thesis seminars where students present their progress and receive structured feedback. Attendance is often mandatory — check your programme requirements.',
      url: 'https://peppi.oulu.fi/',
    ),
    _Item(
      icon: Icons.support_agent_outlined,
      title: 'Writing Clinic',
      description:
          'The university\'s Language and Communication Studies unit runs writing clinic sessions for thesis students. Get personalised help with structure, argument, and academic English.',
      url: 'https://www.oulu.fi/en/for-students/studying/language-and-communication-studies',
    ),
    _Item(
      icon: Icons.science_outlined,
      title: 'Thesis in a Research Group',
      description:
          'Writing your thesis within a research group gives you access to data, supervision, and a collaborative environment. Contact faculty researchers whose topics interest you.',
      url: 'https://research.oulu.fi/',
    ),
  ];

  static const _tools = [
    _Item(
      icon: Icons.local_library_outlined,
      title: 'Jultika – Past Theses',
      description:
          'Browse completed theses and dissertations in the Jultika repository. Reading past work in your area is one of the best ways to understand what is expected.',
      url: 'http://jultika.oulu.fi/',
    ),
    _Item(
      icon: Icons.format_quote_outlined,
      title: 'Zotero – Reference Manager',
      description:
          'Zotero is a free, open-source reference manager that collects, organises, and formats citations. Highly recommended for managing your thesis bibliography.',
      url: 'https://www.zotero.org/',
    ),
    _Item(
      icon: Icons.edit_outlined,
      title: 'Overleaf – LaTeX Editor',
      description:
          'Many IPS thesis students use LaTeX for document formatting. Overleaf is a free online LaTeX editor with collaboration features and IPS thesis templates.',
      url: 'https://www.overleaf.com/',
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
