import 'package:appwrite/appwrite.dart';
import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:community/features/auth/presentation/bloc/auth_event.dart';
import 'package:community/features/auth/presentation/bloc/auth_state.dart';
import 'package:community/features/more/presentation/bloc/more_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordForEmailController =
      TextEditingController();

  bool _didPrefill = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordForEmailController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded(AuthState state) {
    if (_didPrefill) return;

    if (state is AuthAuthenticated) {
      _nameController.text = state.user.name;
      _emailController.text = state.user.email;
      _didPrefill = true;
    }
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _currentPasswordForEmailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and email cannot be empty.'),
        ),
      );
      return;
    }

    context.read<MoreBloc>().add(
          EditProfile(name, email, password),
        );

    context.read<AuthBloc>().add(
          UpdateProfileEvent(name: name),
        );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              currentPasswordController.dispose();
              newPasswordController.dispose();
              confirmPasswordController.dispose();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final currentPassword = currentPasswordController.text.trim();
              final newPassword = newPasswordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

              if (currentPassword.isEmpty ||
                  newPassword.isEmpty ||
                  confirmPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all password fields.'),
                  ),
                );
                return;
              }

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New passwords do not match.'),
                  ),
                );
                return;
              }

              context.read<MoreBloc>().add(
                    ChangePassword(currentPassword, newPassword),
                  );

              Navigator.pop(context);

              currentPasswordController.dispose();
              newPasswordController.dispose();
              confirmPasswordController.dispose();
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<MoreBloc>().add(DeleteAccount());
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MoreBloc, MoreState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully.'),
                ),
              );
            } else if (state is PasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully.'),
                ),
              );
            } else if (state is AccountDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deleted successfully.'),
                ),
              );

              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            } else if (state is ProfileUpdateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Profile Management',
          showSettingsButton: false,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            _prefillIfNeeded(authState);

            if (authState is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (authState is AuthError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(authState.message),
                ),
              );
            }

            if (authState is! AuthAuthenticated) {
              return const Center(
                child: Text('Please log in first.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.12),
                    child: Text(
                      authState.user.name.isNotEmpty
                          ? authState.user.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    authState.user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.user.email,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Edit Profile'),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _currentPasswordForEmailController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password (required for email update)',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildSectionTitle('Account'),
                  _buildActionTile(
                    icon: Icons.lock_reset_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your current password',
                    onTap: _showChangePasswordDialog,
                  ),
                  _buildActionTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out from this account',
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.delete_outline,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    title: 'Delete Account',
                    subtitle: 'Remove this account from the app',
                    onTap: _showDeleteAccountDialog,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<MoreBloc, MoreState>(
                    builder: (context, state) {
                      if (state is MoreInitial) {
                        return const SizedBox.shrink();
                      }

                      if (state is ProfileUpdateFailed) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.2)),
                          ),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state is ProfileUpdated ||
                          state is PasswordChanged ||
                          state is AccountDeleted) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.2)),
                          ),
                          child: Text(
                            state is ProfileUpdated
                                ? 'Profile updated successfully.'
                                : state is PasswordChanged
                                    ? 'Password changed successfully.'
                                    : 'Account deleted successfully.',
                            style: const TextStyle(color: Colors.green),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
