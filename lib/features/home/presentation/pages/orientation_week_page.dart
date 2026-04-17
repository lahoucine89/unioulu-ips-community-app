import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrientationWeekPage extends StatelessWidget {
  const OrientationWeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Orientation Week'),
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
            ..._gettingStarted.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Community & Events'),
            const SizedBox(height: 12),
            ..._community.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.celebration_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Orientation Week',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Everything you need to know to settle into life at IPS and the University of Oulu.',
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

  static const _gettingStarted = [
    _Item(
      icon: Icons.school_outlined,
      title: 'New Students – University Guide',
      description:
          'The official University of Oulu guide for new students covers registration, IT accounts, library access, and your first steps on campus.',
      url: 'https://www.oulu.fi/en/for-students/new-students',
    ),
    _Item(
      icon: Icons.badge_outlined,
      title: 'Student Registration',
      description:
          'Confirm your study right each academic year through the university\'s online registration system. This is required to remain an active student.',
      url: 'https://www.oulu.fi/en/for-students/new-students/registration',
    ),
    _Item(
      icon: Icons.laptop_outlined,
      title: 'IT Services & University Account',
      description:
          'Set up your university email, VPN access, Office 365, and other IT services through the university IT Services portal.',
      url: 'https://www.oulu.fi/en/for-students/it-services',
    ),
    _Item(
      icon: Icons.map_outlined,
      title: 'Campus Map',
      description:
          'Navigate the Linnanmaa campus with the interactive campus map. Find lecture halls, offices, the library, restaurants, and sports facilities.',
      url: 'https://www.oulu.fi/en/university/campuses-and-services',
    ),
  ];

  static const _community = [
    _Item(
      icon: Icons.flight_outlined,
      title: 'ESN Oulu – Welcome Events',
      description:
          'ESN Oulu runs an intensive welcome programme for new international students including city tours, icebreaker events, and trips around Finland.',
      url: 'https://www.esnoulu.com/',
    ),
    _Item(
      icon: Icons.groups_outlined,
      title: 'Student Tutors',
      description:
          'Each new student group is assigned a student tutor who can help you settle in, answer questions, and introduce you to campus life and traditions.',
      url: 'https://www.oulu.fi/en/for-students/studying/student-tutoring',
    ),
    _Item(
      icon: Icons.event_available_outlined,
      title: 'Orientation Events Calendar',
      description:
          'Check the university event calendar for orientation week activities, guild intro events, campus tours, and welcome dinners at the start of the semester.',
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
