import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5F0),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF20251F),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EBE2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Color(0xFF4E574B),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? 'News Reader',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF20251F),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? user?.phoneNumber ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF737A71),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF20251F),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 5,
                  ),
                  leading: _iconContainer(Icons.dark_mode_outlined),
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Change the app appearance',
                  ),
                  trailing: Switch(
                    value: theme.isDarkMode,
                    onChanged: (_) {
                      theme.toggleTheme();
                    },
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 18,
                  endIndent: 18,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 5,
                  ),
                  leading: _iconContainer(Icons.notifications_none),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Manage news notifications',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF20251F),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              leading: _iconContainer(
                Icons.logout,
                color: const Color(0xFFB3261E),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB3261E),
                ),
              ),
              subtitle: const Text(
                'Sign out of your account',
              ),
              onTap: () async {
                await auth.logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconContainer(
    IconData icon, {
    Color color = const Color(0xFF4E574B),
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}