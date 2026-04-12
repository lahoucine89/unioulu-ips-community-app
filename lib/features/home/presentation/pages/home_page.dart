import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/services/http_appwrite_service.dart';
import '../../../announcement/presentation/pages/announcement_page.dart';
import '../../../announcement/presentation/widgets/announcement_form.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../community/presentation/widgets/latest_community_posts_widget.dart';
import '../../../events/presentation/widgets/add_event_form.dart';
import '../../../language/presentation/bloc/language_bloc.dart';
import '../widgets/add_topic_form.dart';
import '../widgets/latest_event.dart';
import '../widgets/topic_list_widget.dart';
import 'topic_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => _buildForAuthState(context, state),
    );
  }

  Widget _buildForAuthState(BuildContext context, AuthState state) {
    if (state is! AuthAuthenticated) return _buildUnauthenticated();

    final locale =
        context.select((LocalizationBloc b) => b.state.locale.languageCode);
    final service = GetIt.instance<AppwriteService>();
    final userName = state.user.name;

    if (state.labels.contains('admin')) {
      return AdminHomePage(
        locale: locale,
        service: service,
        userName: userName,
      );
    }

    if (state.labels.contains('moderator')) {
      return ModeratorHomePage(
        locale: locale,
        service: service,
        userName: userName,
      );
    }

    return UserHomePage(
      locale: locale,
      service: service,
      userName: userName,
    );
  }

  Widget _buildUnauthenticated() {
    return const Scaffold(
      appBar: CustomAppBar(title: 'WeConnect'),
      body: Center(
        child: Text('Please log in to access the home page.'),
      ),
    );
  }
}

// ==================== ADMIN ====================

class AdminHomePage extends StatelessWidget {
  final String locale;
  final AppwriteService service;
  final String userName;

  const AdminHomePage({
    super.key,
    required this.locale,
    required this.service,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'WeConnect'),
        body: Column(
          children: [
            const AdminTabBar(),
            Expanded(child: _buildTabView()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      children: [
        const AdminDashboard(),
        UserContentView(
          locale: locale,
          service: service,
          userName: userName,
        ),
      ],
    );
  }
}

class AdminTabBar extends StatelessWidget {
  const AdminTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      color: primary,
      child: const TabBar(
        tabs: [
          Tab(
            text: 'Admin Dashboard',
            icon: Icon(Icons.admin_panel_settings),
          ),
          Tab(
            text: 'User View',
            icon: Icon(Icons.person),
          ),
        ],
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'Welcome, Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            AdminButton(label: 'Add New Event', page: EventForm()),
            AdminButton(
              label: 'Add New Announcement',
              page: AddAnnouncementForm(),
            ),
            AdminButton(label: 'Add New Topic', page: TopicForm()),
            AdminPlaceholderButton(label: 'Manage Users'),
            AdminPlaceholderButton(label: 'Manage Content'),
            SizedBox(height: 20),
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  final String label;
  final Widget page;

  const AdminButton({
    super.key,
    required this.label,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () => _navigate(context),
        child: Text(label),
      ),
    );
  }

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class AdminPlaceholderButton extends StatelessWidget {
  final String label;

  const AdminPlaceholderButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}

// ==================== MODERATOR ====================

class ModeratorHomePage extends StatelessWidget {
  final String locale;
  final AppwriteService service;
  final String userName;

  const ModeratorHomePage({
    super.key,
    required this.locale,
    required this.service,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildTabView(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Community App'),
      bottom: const TabBar(
        tabs: [
          Tab(
            text: 'Moderator Tools',
            icon: Icon(Icons.shield),
          ),
          Tab(
            text: 'User View',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      children: [
        const ModeratorDashboard(),
        UserContentView(
          locale: locale,
          service: service,
          userName: userName,
        ),
      ],
    );
  }
}

class ModeratorDashboard extends StatelessWidget {
  const ModeratorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'Welcome, Moderator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            AdminButton(label: 'Add New Event', page: EventForm()),
            AdminPlaceholderButton(label: 'Manage Content'),
            SizedBox(height: 20),
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== USER ====================

class UserHomePage extends StatelessWidget {
  final String locale;
  final AppwriteService service;
  final String userName;

  const UserHomePage({
    super.key,
    required this.locale,
    required this.service,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'WeConnect'),
      body: UserContentView(
        locale: locale,
        service: service,
        userName: userName,
      ),
    );
  }
}

class UserContentView extends StatelessWidget {
  final String locale;
  final AppwriteService service;
  final String userName;

  const UserContentView({
    super.key,
    required this.locale,
    required this.service,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserGreeting(userName: userName),
            const SizedBox(height: 8),
            const AnnouncementButton(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Topics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            TopicListWidget(
              currentLocale: locale,
              appwriteService: service,
              onTopicSelected: (topic) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopicPage(
                      topic: topic,
                      currentLocale: locale,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const LatestEventsWidget(),
            const SizedBox(height: 20),
            const LatestCommunityPostsWidget(),
          ],
        ),
      ),
    );
  }
}

class UserGreeting extends StatelessWidget {
  final String userName;

  const UserGreeting({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Let's explore what's new in IPS...",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.key_outlined,
              color: theme.colorScheme.primary,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementButton extends StatelessWidget {
  const AnnouncementButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _navigate(context),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Announcements',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'See the latest official updates and campus news.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AnnouncementsPage(),
      ),
    );
  }
}
