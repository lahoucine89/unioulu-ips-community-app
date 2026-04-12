import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UniversityLibraryPage extends StatelessWidget {
  const UniversityLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'University Library'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'E-Books & Databases'),
            const SizedBox(height: 12),
            ..._ebooks.map((item) => _LibraryCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Research Papers & Publications'),
            const SizedBox(height: 12),
            ..._research.map((item) => _LibraryCard(item: item, theme: theme)),
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
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.08),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
            child: Icon(
              Icons.local_library_outlined,
              color: theme.colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'University of Oulu Library',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Access e-books, journals, and research papers available to University of Oulu students.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  static const _ebooks = [
    _LibraryItem(
      icon: Icons.menu_book_outlined,
      title: 'Oula – Library Catalogue',
      description:
          'Search and borrow books, e-books, and other materials from the University of Oulu library collection.',
      url: 'https://oula.finna.fi/',
    ),
    _LibraryItem(
      icon: Icons.library_books_outlined,
      title: 'Ebsco eBooks',
      description:
          'Thousands of academic e-books across engineering, science, and technology — accessible with your university credentials.',
      url: 'https://www.ebsco.com/products/ebooks',
    ),
    _LibraryItem(
      icon: Icons.computer_outlined,
      title: 'ProQuest Ebook Central',
      description:
          'Browse and read e-books online or download chapters for offline reading. Log in with your university account.',
      url: 'https://ebookcentral.proquest.com/',
    ),
    _LibraryItem(
      icon: Icons.auto_stories_outlined,
      title: 'Springer Link',
      description:
          'Access Springer e-books and book series in STEM fields. University of Oulu has institutional access to a large collection.',
      url: 'https://link.springer.com/',
    ),
  ];

  static const _research = [
    _LibraryItem(
      icon: Icons.science_outlined,
      title: 'Jultika – University Repository',
      description:
          'The official open-access publication archive of the University of Oulu. Find dissertations, theses, and research articles.',
      url: 'http://jultika.oulu.fi/',
    ),
    _LibraryItem(
      icon: Icons.article_outlined,
      title: 'Web of Science',
      description:
          'Search millions of peer-reviewed articles across all disciplines. Available through the university library subscription.',
      url: 'https://www.webofscience.com/',
    ),
    _LibraryItem(
      icon: Icons.search_outlined,
      title: 'Scopus',
      description:
          'The world\'s largest abstract and citation database for peer-reviewed literature. Access via university network or VPN.',
      url: 'https://www.scopus.com/',
    ),
    _LibraryItem(
      icon: Icons.biotech_outlined,
      title: 'IEEE Xplore',
      description:
          'Full-text access to IEEE journals, conference papers, and standards — essential for engineering and computer science research.',
      url: 'https://ieeexplore.ieee.org/',
    ),
    _LibraryItem(
      icon: Icons.public_outlined,
      title: 'Google Scholar',
      description:
          'Search across academic publications. Link your university account to access full-text articles available through Oulu library.',
      url: 'https://scholar.google.com/',
    ),
  ];
}

class _LibraryItem {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _LibraryItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });
}

class _LibraryCard extends StatelessWidget {
  final _LibraryItem item;
  final ThemeData theme;

  const _LibraryCard({required this.item, required this.theme});

  Future<void> _launch() async {
    final uri = Uri.parse(item.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
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
                child: Icon(
                  item.icon,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.45,
                      ),
                    ),
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
