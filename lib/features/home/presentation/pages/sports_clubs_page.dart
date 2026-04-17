import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SportsClubsPage extends StatelessWidget {
  const SportsClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sports Clubs'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Team Sports'),
            const SizedBox(height: 12),
            ..._team.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Individual Sports & Clubs'),
            const SizedBox(height: 12),
            ..._individual.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.sports_basketball_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sports Clubs',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Join a student sports club and compete, train, and socialise with fellow students.',
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

  static const _team = [
    _Item(
      icon: Icons.sports_soccer_outlined,
      title: 'Football & Futsal',
      description:
          'The university and Tietokilta organise casual football and futsal matches regularly. All skill levels are welcome — check the guild\'s event calendar to join.',
      url: 'https://tietokilta.fi/',
    ),
    _Item(
      icon: Icons.sports_basketball_outlined,
      title: 'Basketball',
      description:
          'Basketball courts are bookable through UniSport. Student groups also organise informal pickup games — a great way to meet new people and stay active.',
      url: 'https://www.unisport.fi/oulu/vuorot/',
    ),
    _Item(
      icon: Icons.sports_hockey_outlined,
      title: 'Floorball (Salibandy)',
      description:
          'Floorball is hugely popular among Finnish students. Many guilds and student associations run floorball teams competing in the university league.',
      url: 'https://www.unisport.fi/oulu/',
    ),
    _Item(
      icon: Icons.sports_tennis_outlined,
      title: 'Badminton & Racket Sports',
      description:
          'Badminton courts can be booked at UniSport facilities. Rackets are available to borrow. The university also has a student tennis club with regular sessions.',
      url: 'https://www.unisport.fi/oulu/vuorot/',
    ),
  ];

  static const _individual = [
    _Item(
      icon: Icons.directions_run_outlined,
      title: 'Running Club',
      description:
          'Join the university running club for organised group runs around the Oulujoki riverside trail and Linnanmaa campus paths. Sessions run year-round, including winter.',
      url: 'https://www.unisport.fi/oulu/',
    ),
    _Item(
      icon: Icons.sports_martial_arts_outlined,
      title: 'Martial Arts',
      description:
          'Oulu has active student martial arts clubs including judo, karate, and Brazilian jiu-jitsu. Contact the Student Union (SYY) for a directory of affiliated clubs.',
      url: 'https://www.svy.fi/',
    ),
    _Item(
      icon: Icons.sports_esports_outlined,
      title: 'eSports & Gaming',
      description:
          'Tietokilta and other guilds organise LAN parties and eSports tournaments throughout the year. A great way to compete and socialise without leaving the campus.',
      url: 'https://tietokilta.fi/',
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
