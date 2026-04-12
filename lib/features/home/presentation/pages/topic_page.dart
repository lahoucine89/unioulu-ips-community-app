import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../data/models/topic_model.dart';
import 'university_library_page.dart';

class TopicPage extends StatelessWidget {
  final TopicModel topic;
  final String currentLocale;

  const TopicPage({
    super.key,
    required this.topic,
    required this.currentLocale,
  });

  String get _localizedTitle {
    switch (currentLocale) {
      case 'fi':
        return topic.textFi.isNotEmpty ? topic.textFi : topic.textEn;
      case 'sv':
        return topic.textSv.isNotEmpty ? topic.textSv : topic.textEn;
      default:
        return topic.textEn;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _TopicConfig.forTopic(topic);

    return Scaffold(
      appBar: CustomAppBar(title: _localizedTitle),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopicHeader(config: config, theme: theme),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Resources & Info',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...config.cards.map(
              (card) => _TopicInfoCard(card: card, theme: theme),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicHeader extends StatelessWidget {
  final _TopicConfig config;
  final ThemeData theme;

  const _TopicHeader({required this.config, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
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
              config.icon,
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
                  config.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  config.subtitle,
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
}

class _TopicInfoCard extends StatelessWidget {
  final _CardData card;
  final ThemeData theme;

  const _TopicInfoCard({required this.card, required this.theme});

  void _handleTap(BuildContext context) {
    if (card.navigateTo == 'university_library') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UniversityLibraryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClickable = card.navigateTo != null;

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isClickable ? () => _handleTap(context) : null,
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
                  card.icon,
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
                            card.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isClickable)
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.description,
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

// ─── Data classes ────────────────────────────────────────────────────────────

class _CardData {
  final IconData icon;
  final String title;
  final String description;
  final String? navigateTo;

  const _CardData({
    required this.icon,
    required this.title,
    required this.description,
    this.navigateTo,
  });
}

class _TopicConfig {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<_CardData> cards;

  const _TopicConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cards,
  });

  static _TopicConfig forTopic(TopicModel topic) {
    final key = topic.textEn.trim().toLowerCase();

    if (key.contains('academic') || key.contains('study') || key.contains('course')) {
      return _academic;
    }
    if (key.contains('student life') || key.contains('student')) {
      return _studentLife;
    }
    if (key.contains('sport')) {
      return _sports;
    }
    if (key.contains('culture') || key.contains('art')) {
      return _culture;
    }
    if (key.contains('career') || key.contains('job') || key.contains('work')) {
      return _career;
    }
    if (key.contains('research') || key.contains('science')) {
      return _research;
    }

    // Fallback — generic page
    return _TopicConfig(
      icon: Icons.category_outlined,
      title: topic.textEn,
      subtitle: 'Explore everything related to ${topic.textEn} at IPS.',
      cards: [
        const _CardData(
          icon: Icons.info_outline,
          title: 'More coming soon',
          description: 'Content for this topic is being prepared. Check back later!',
        ),
      ],
    );
  }

  // ── Academic ──────────────────────────────────────────────────────────────

  static const _academic = _TopicConfig(
    icon: Icons.menu_book_outlined,
    title: 'Academic',
    subtitle: 'Everything you need to succeed in your studies at IPS.',
    cards: [
      _CardData(
        icon: Icons.library_books_outlined,
        title: 'University Library',
        description:
            'Access thousands of journals, e-books, and research papers through the University of Oulu library portal. Available 24/7 online.',
        navigateTo: 'university_library',
      ),
      _CardData(
        icon: Icons.schedule_outlined,
        title: 'Exam Periods',
        description:
            'The exam period typically runs at the end of each study period. Check WebOodi or Peppi for your personal exam schedule and registration deadlines.',
      ),
      _CardData(
        icon: Icons.people_outline,
        title: 'Peer Tutoring',
        description:
            'Struggling with a course? IPS organises peer tutoring sessions where senior students help you navigate difficult topics.',
      ),
      _CardData(
        icon: Icons.app_registration_outlined,
        title: 'Course Registration',
        description:
            'Register for courses through the Peppi student portal. Registration windows open at the start of each study period — act fast, popular courses fill quickly.',
      ),
      _CardData(
        icon: Icons.tips_and_updates_outlined,
        title: 'Study Tips',
        description:
            'Break your study sessions into focused 25-minute blocks (Pomodoro technique), take regular breaks, and form study groups with classmates.',
      ),
      _CardData(
        icon: Icons.support_agent_outlined,
        title: 'Student Counselling',
        description:
            'The IPS study counsellor can help you plan your degree, choose electives, and navigate any academic challenges. Book an appointment via email.',
      ),
    ],
  );

  // ── Student Life ──────────────────────────────────────────────────────────

  static const _studentLife = _TopicConfig(
    icon: Icons.groups_outlined,
    title: 'Student Life',
    subtitle: 'Make the most of your time at the University of Oulu.',
    cards: [
      _CardData(
        icon: Icons.group_work_outlined,
        title: 'Student Clubs & Guilds',
        description:
            'Tietokilta is the official guild of IPS students. Join to connect with peers, attend events, and access guild benefits like merchandise and sauna nights.',
      ),
      _CardData(
        icon: Icons.home_outlined,
        title: 'Student Housing',
        description:
            'The Student Union of University of Oulu (SYY) offers affordable housing across the city. Apply early — demand is high at the start of each academic year.',
      ),
      _CardData(
        icon: Icons.restaurant_outlined,
        title: 'Campus Restaurants',
        description:
            'Enjoy subsidised meals at Kerttu, Kastari, and other campus cafeterias with your student card. Lunch is typically served 10:30–13:30 on weekdays.',
      ),
      _CardData(
        icon: Icons.celebration_outlined,
        title: 'Orientation Week',
        description:
            'New to Oulu? The orientation week (fuksivuosi) is packed with activities to help you settle in, make friends, and learn university life traditions.',
      ),
      _CardData(
        icon: Icons.card_membership_outlined,
        title: 'Student Card (Frank)',
        description:
            'Activate your Frank student card to get discounts on transport, culture, and shopping across Finland. The digital version is available in the Frank app.',
      ),
      _CardData(
        icon: Icons.psychology_outlined,
        title: 'Student Wellbeing',
        description:
            'FSHS (Finnish Student Health Service) provides healthcare, mental health support, and dental services for students. Register online to access services.',
      ),
    ],
  );

  // ── Sports ────────────────────────────────────────────────────────────────

  static const _sports = _TopicConfig(
    icon: Icons.sports_soccer_outlined,
    title: 'Sports',
    subtitle: 'Stay active and healthy with sports at the University of Oulu.',
    cards: [
      _CardData(
        icon: Icons.fitness_center_outlined,
        title: 'UniSport Facilities',
        description:
            'UniSport offers gyms, swimming pools, group fitness classes, and sports halls across campus. A semester pass is available at a student-friendly price.',
      ),
      _CardData(
        icon: Icons.sports_basketball_outlined,
        title: 'Sports Clubs',
        description:
            'Join a university sports club — from football and basketball to floorball and badminton. Clubs welcome all skill levels, from beginners to competitive players.',
      ),
      _CardData(
        icon: Icons.emoji_events_outlined,
        title: 'Upcoming Tournaments',
        description:
            'Inter-university tournaments and intramural competitions are held throughout the year. Check the UniSport notice board or ask your guild for the latest schedule.',
      ),
      _CardData(
        icon: Icons.directions_run_outlined,
        title: 'Running & Outdoor Activities',
        description:
            'Oulu has excellent running and cycling paths year-round. The Oulujoki riverbank route is a favourite — 5 km of scenic riverside trail right by campus.',
      ),
      _CardData(
        icon: Icons.self_improvement_outlined,
        title: 'Wellness & Mindfulness',
        description:
            'UniSport runs weekly yoga and mindfulness classes. These sessions are a great way to relieve study stress and recharge.',
      ),
      _CardData(
        icon: Icons.pool_outlined,
        title: 'Swimming & Winter Sports',
        description:
            'The campus swimming pool is open to students year-round. In winter, nearby slopes and frozen lakes make skiing and ice-skating easily accessible.',
      ),
    ],
  );

  // ── Culture ───────────────────────────────────────────────────────────────

  static const _culture = _TopicConfig(
    icon: Icons.palette_outlined,
    title: 'Culture',
    subtitle: 'Experience art, music, and diverse cultures at IPS.',
    cards: [
      _CardData(
        icon: Icons.theater_comedy_outlined,
        title: 'Student Theatre',
        description:
            'The university student theatre puts on several productions each year. Auditions are open to all students — no prior experience needed.',
      ),
      _CardData(
        icon: Icons.music_note_outlined,
        title: 'Music Groups',
        description:
            'From the university choir to jazz ensembles, there are multiple student music groups to join or follow. Concerts are held in the Linnanmaa campus hall.',
      ),
      _CardData(
        icon: Icons.public_outlined,
        title: 'International Student Events',
        description:
            'ESN Oulu (Erasmus Student Network) organises cultural exchange nights, language cafes, and international dinners to celebrate global diversity on campus.',
      ),
      _CardData(
        icon: Icons.brush_outlined,
        title: 'Art Exhibitions',
        description:
            'Student art exhibitions are regularly held in campus hallways and the Tellus Innovation Arena. Keep an eye on the university event calendar for openings.',
      ),
      _CardData(
        icon: Icons.translate_outlined,
        title: 'Language Café',
        description:
            'Practice Finnish, English, or other languages in a relaxed setting. Language cafés are weekly informal meetups hosted by international student groups.',
      ),
      _CardData(
        icon: Icons.festival_outlined,
        title: 'Annual Celebrations',
        description:
            'Don\'t miss Wappu (May Day), the biggest student celebration in Finland, or the traditional guild anniversary parties held throughout the year.',
      ),
    ],
  );

  // ── Career ────────────────────────────────────────────────────────────────

  static const _career = _TopicConfig(
    icon: Icons.work_outline,
    title: 'Career',
    subtitle: 'Build your future from day one at IPS.',
    cards: [
      _CardData(
        icon: Icons.search_outlined,
        title: 'Job Board',
        description:
            'Find part-time jobs, internships, and thesis work positions on the University of Oulu career portal and the Tietokilta job board updated weekly.',
      ),
      _CardData(
        icon: Icons.handshake_outlined,
        title: 'Career Fair',
        description:
            'The annual IPS career fair brings together top tech companies and students. It\'s a great chance to network, learn about open roles, and hand in your CV.',
      ),
      _CardData(
        icon: Icons.description_outlined,
        title: 'CV & Cover Letter Workshops',
        description:
            'The university career services team runs free CV review sessions and cover letter workshops. Book a slot through the career services portal.',
      ),
      _CardData(
        icon: Icons.business_center_outlined,
        title: 'Internship Guide',
        description:
            'Many IPS programmes require a practical training period. Start searching early — the best internships at Nokia, Ericsson, and local tech firms fill up fast.',
      ),
      _CardData(
        icon: Icons.people_alt_outlined,
        title: 'Alumni Network',
        description:
            'Connect with IPS alumni through LinkedIn and the university alumni association. Mentoring programmes pair students with experienced professionals.',
      ),
      _CardData(
        icon: Icons.lightbulb_outline,
        title: 'Entrepreneurship',
        description:
            'Interested in starting your own company? BusinessOulu and the university\'s Kerttu Saalasti Institute offer startup support, mentoring, and funding opportunities.',
      ),
    ],
  );

  // ── Research ──────────────────────────────────────────────────────────────

  static const _research = _TopicConfig(
    icon: Icons.science_outlined,
    title: 'Research',
    subtitle: 'Explore the cutting-edge research happening at IPS.',
    cards: [
      _CardData(
        icon: Icons.groups_2_outlined,
        title: 'Research Groups',
        description:
            'IPS hosts world-class research groups including INTERACT, BIOMIMETICS, and UBICOMP. Visit the faculty website to learn about ongoing projects and collaboration opportunities.',
      ),
      _CardData(
        icon: Icons.school_outlined,
        title: 'Thesis Support',
        description:
            'Writing your bachelor\'s or master\'s thesis? The faculty offers thesis seminars, writing clinics, and one-on-one supervision sessions throughout the year.',
      ),
      _CardData(
        icon: Icons.article_outlined,
        title: 'Publications & Journals',
        description:
            'Access IPS research publications through the university repository (Jultika). You can also follow faculty researchers on Google Scholar and ResearchGate.',
      ),
      _CardData(
        icon: Icons.monetization_on_outlined,
        title: 'Research Funding',
        description:
            'Look for grants from the Academy of Finland, Business Finland, and EU Horizon programmes. The faculty research office can guide you through the application process.',
      ),
      _CardData(
        icon: Icons.event_note_outlined,
        title: 'Conferences & Seminars',
        description:
            'IPS regularly hosts and participates in international conferences. Student travel grants are available for presenting papers at relevant academic venues.',
      ),
      _CardData(
        icon: Icons.work_history_outlined,
        title: 'Research Assistant Positions',
        description:
            'Research assistant (RA) positions within IPS labs are posted on the faculty website and Tietokilta job board. These are great for gaining hands-on research experience.',
      ),
    ],
  );
}
