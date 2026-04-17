import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentWellbeingPage extends StatelessWidget {
  const StudentWellbeingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Wellbeing'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildSectionTitle(theme, 'Health Services'),
            const SizedBox(height: 12),
            ..._health.map((item) => _InfoCard(item: item, theme: theme)),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, 'Mental Health & Support'),
            const SizedBox(height: 12),
            ..._mental.map((item) => _InfoCard(item: item, theme: theme)),
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
            child: Icon(Icons.psychology_outlined, color: theme.colorScheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Wellbeing',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Healthcare, mental health support, and wellbeing resources for IPS students.',
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

  static const _health = [
    _Item(
      icon: Icons.local_hospital_outlined,
      title: 'FSHS – Student Health Service',
      description:
          'The Finnish Student Health Service (FSHS/YTHS) provides general healthcare, vaccinations, and dental services. Register online to book at the Oulu unit.',
      url: 'https://www.yths.fi/en/',
    ),
    _Item(
      icon: Icons.medical_services_outlined,
      title: 'Book a Health Appointment',
      description:
          'Book nurse, doctor, or specialist appointments through the FSHS online service. Available 24/7 — you can also call the advice line for urgent guidance.',
      url: 'https://www.yths.fi/en/appointments/',
    ),
    _Item(
      icon: Icons.healing_outlined,
      title: 'Dental Care',
      description:
          'FSHS provides subsidised dental check-ups and treatments for students. Book your first appointment soon after arriving in Oulu as slots fill up quickly.',
      url: 'https://www.yths.fi/en/services/dental-care/',
    ),
  ];

  static const _mental = [
    _Item(
      icon: Icons.psychology_outlined,
      title: 'Mental Health Counselling',
      description:
          'FSHS offers free psychological counselling sessions for students experiencing stress, anxiety, burnout, or other mental health challenges. Book online.',
      url: 'https://www.yths.fi/en/services/mental-health/',
    ),
    _Item(
      icon: Icons.church_outlined,
      title: 'University Chaplaincy',
      description:
          'The university chaplain offers confidential one-on-one conversations for all students regardless of background or beliefs — a good resource when you need to talk.',
      url: 'https://www.oulu.fi/en/for-students/student-services/chaplaincy',
    ),
    _Item(
      icon: Icons.self_improvement_outlined,
      title: 'UniSport – Wellness Classes',
      description:
          'Regular physical activity is one of the best ways to manage stress. UniSport offers yoga, pilates, and mindfulness classes weekly on campus.',
      url: 'https://www.unisport.fi/oulu/',
    ),
    _Item(
      icon: Icons.crisis_alert_outlined,
      title: 'Crisis Support – MIELI',
      description:
          'MIELI Mental Health Finland runs a national crisis helpline available 24/7. If you are going through a difficult time, don\'t hesitate to reach out.',
      url: 'https://mieli.fi/en/crisis-helpline/',
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
