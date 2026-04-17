import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageCafePage extends StatelessWidget {
  const LanguageCafePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Language Café'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Language Practice'),
            const SizedBox(height: 12),
            ..._practice.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Language Learning Resources'),
            const SizedBox(height: 12),
            ..._resources.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.translate_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language Café',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Practise Finnish, English, or any language in a relaxed, welcoming setting.',
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

  static const _practice = [
    _Item(
      icon: Icons.coffee_outlined,
      title: 'ESN Language Café',
      description:
          'ESN Oulu hosts regular language café sessions where students meet informally to practise different languages over coffee. All languages and levels are welcome.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.record_voice_over_outlined,
      title: 'Finnish Language Practice',
      description:
          'Many international students want to learn Finnish. The language café and university language courses provide structured opportunities to practise with native speakers.',
      url: 'https://www.oulu.fi/en/for-students/studying/language-and-communication-studies',
    ),
    _Item(
      icon: Icons.forum_outlined,
      title: 'Tandem Language Exchange',
      description:
          'The university facilitates tandem language exchange pairs — you teach your native language and learn your partner\'s in return. Contact Language Services to sign up.',
      url: 'https://www.oulu.fi/en/for-students/studying/language-and-communication-studies',
    ),
  ];

  static const _resources = [
    _Item(
      icon: Icons.school_outlined,
      title: 'Finnish Language Courses',
      description:
          'The university offers free Finnish language courses at different levels for international students. Register through Peppi at the start of each semester.',
      url: 'https://www.oulu.fi/en/for-students/studying/language-and-communication-studies',
    ),
    _Item(
      icon: Icons.phone_android_outlined,
      title: 'Duolingo – Finnish Practice',
      description:
          'Supplement classroom Finnish with daily Duolingo practice. The Finnish course is surprisingly comprehensive and free for all learners.',
      url: 'https://www.duolingo.com/course/fi/en/Learn-Finnish',
    ),
    _Item(
      icon: Icons.library_books_outlined,
      title: 'City Library Language Resources',
      description:
          'The Oulu City Library (Oulun kaupunginkirjasto) has a wide selection of language learning materials, dictionaries, and multilingual books available for free borrowing.',
      url: 'https://www.ouka.fi/oulu/kirjasto',
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
