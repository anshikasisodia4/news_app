import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            subtitle: Text(
              authProvider.user?.email ??
                  authProvider.user?.phoneNumber ??
                  'User',
            ),
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text(
              'Change the appearance of the app',
            ),
            value: themeProvider.isDarkMode,
            onChanged: (_) {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text(
                      'Are you sure you want to logout?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          logout(context);
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}