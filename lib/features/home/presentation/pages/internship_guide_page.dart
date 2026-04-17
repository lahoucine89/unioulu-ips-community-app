import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InternshipGuidePage extends StatelessWidget {
  const InternshipGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Internship Guide'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Find an Internship'),
            const SizedBox(height: 12),
            ..._find.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Major Employers in Oulu'),
            const SizedBox(height: 12),
            ..._employers.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.business_center_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Internship Guide',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Find internships and practical training opportunities in Oulu\'s thriving tech industry.',
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
      title: 'University Career Portal',
      description:
          'The university career portal lists internship positions from companies actively recruiting IPS students. Many postings are exclusive to university students.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
    _Item(
      icon: Icons.computer_outlined,
      title: 'Tietokilta Job Board',
      description:
          'The IPS guild job board is updated regularly with internship and thesis work opportunities from tech companies in the Oulu region and across Finland.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.school_outlined,
      title: 'Practical Training Requirements',
      description:
          'Many IPS programmes require a practical training period as part of the degree. Check your programme\'s curriculum in Peppi for credit requirements and guidance.',
      url: 'https://peppi.oulu.fi/',
    ),
    _Item(
      icon: Icons.support_agent_outlined,
      title: 'Career Counselling',
      description:
          'The university career counsellor can help you identify internship opportunities that match your skills and interests and guide you through the application process.',
      url: 'https://www.oulu.fi/en/for-students/career-services',
    ),
  ];

  static const _employers = [
    _Item(
      icon: Icons.business_outlined,
      title: 'Nokia – Telecom & Networks',
      description:
          'Nokia is one of Oulu\'s largest employers and regularly recruits IPS interns and thesis workers. Check Nokia\'s careers site for current student openings.',
      url: 'https://www.nokia.com/about-us/careers/student-and-early-career-opportunities/',
    ),
    _Item(
      icon: Icons.wifi_outlined,
      title: 'Ericsson – 5G & Mobile Technology',
      description:
          'Ericsson has a significant presence in Oulu and offers internships in 5G network development, software engineering, and radio technology for IPS students.',
      url: 'https://www.ericsson.com/en/careers/find-your-place/students-and-graduates',
    ),
    _Item(
      icon: Icons.lightbulb_outlined,
      title: 'BusinessOulu – Local Startups',
      description:
          'BusinessOulu connects students with local startups and SMEs looking for intern talent. A great option if you want a hands-on role in a growing Oulu company.',
      url: 'https://www.businessoulu.com/',
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
