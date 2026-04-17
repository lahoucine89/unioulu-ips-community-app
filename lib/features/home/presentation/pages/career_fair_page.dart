import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerFairPage extends StatelessWidget {
  const CareerFairPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Career Fair'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Career Fairs'),
            const SizedBox(height: 12),
            ..._fairs.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Networking & Preparation'),
            const SizedBox(height: 12),
            ..._prep.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.handshake_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Career Fair',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Meet top companies, discover opportunities, and build your professional network.',
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

  static const _fairs = [
    _Item(
      icon: Icons.event_outlined,
      title: 'Digiura – IPS Career Fair',
      description:
          'Digiura is the annual career fair for IPS students at the University of Oulu. Leading tech companies including Nokia, Ericsson, and local firms attend each year.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.business_outlined,
      title: 'Rekry – University Career Events',
      description:
          'The university organises multiple career events and company presentations throughout the academic year. These are great opportunities for informal networking.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.location_city_outlined,
      title: 'Pohjois-Suomi Recruitment Fair',
      description:
          'A regional recruitment event covering employers from Northern Finland. Includes companies from technology, engineering, healthcare, and public sector.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
  ];

  static const _prep = [
    _Item(
      icon: Icons.people_alt_outlined,
      title: 'LinkedIn – Build Your Profile',
      description:
          'Before attending a career fair, make sure your LinkedIn profile is complete and up to date. Recruiters often look you up before or after meeting you at events.',
      url: 'https://www.linkedin.com/',
    ),
    _Item(
      icon: Icons.description_outlined,
      title: 'CV Preparation Tips',
      description:
          'Finnish CVs are typically one page, concise, and focused on skills and achievements. Check the university career services for CV templates and review sessions.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.question_answer_outlined,
      title: 'Interview Preparation',
      description:
          'Practice common interview questions and research companies before attending fairs. The university career services team offers mock interview sessions on request.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
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
