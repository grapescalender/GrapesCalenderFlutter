import 'package:flutter/material.dart';

/// Profile page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Column(
      children: [
        AppBar(
          title: const Text('Profile'),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Farmer Name',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'farmer@example.com',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings options
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    onTap: () {
                      // Edit profile
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    onTap: () {
                      // Change password
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Change Language'),
                    onTap: () {
                      // Change language
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // Toggle dark mode
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      // Logout
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
}
