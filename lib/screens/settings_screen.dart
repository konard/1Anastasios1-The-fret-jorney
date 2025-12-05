import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_progress.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // App info section
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('The Fret Journey v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'The Fret Journey',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.music_note, size: 48),
                children: [
                  const Text(
                    'An educational app for guitarists that helps them learn the notes on the fretboard in an interactive way.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Every note is a step, every fret is a direction — welcome to your musical journey.',
                  ),
                ],
              );
            },
          ),

          const Divider(),

          // Training settings
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Training Mode'),
            subtitle: const Text('Standard (all notes)'),
            onTap: () {
              // TODO: Implement training mode selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Training mode settings coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('Sound Settings'),
            subtitle: const Text('Configure audio feedback'),
            onTap: () {
              // TODO: Implement sound settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sound settings coming soon!'),
                ),
              );
            },
          ),

          const Divider(),

          // Data management
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Cloud Sync'),
            subtitle: const Text('Sync your progress (Firebase)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Firebase sync
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cloud sync coming soon!'),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Progress'),
            subtitle: const Text('Save your statistics'),
            onTap: () {
              // TODO: Implement export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export feature coming soon!'),
                ),
              );
            },
          ),

          const Divider(),

          // Reset progress
          Consumer<UserProgress>(
            builder: (context, progress, child) {
              return ListTile(
                leading: const Icon(Icons.refresh, color: Colors.orange),
                title: const Text('Reset Progress'),
                subtitle: const Text('Clear all data and start over'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Progress?'),
                      content: const Text(
                        'This will delete all your progress, statistics, and XP. This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Reset progress
                            await progress.saveProgress();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Progress reset!'),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          const Divider(),

          // Help and support
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Tutorial'),
            subtitle: const Text('Learn how to use the app'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Play'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '1. Tap "Start Training" on the home screen',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '2. You\'ll see a note displayed (e.g., "C", "D#")',
                        ),
                        SizedBox(height: 8),
                        Text(
                          '3. Play that note on your guitar',
                        ),
                        SizedBox(height: 8),
                        Text(
                          '4. The app listens through your microphone',
                        ),
                        SizedBox(height: 8),
                        Text(
                          '5. Get instant feedback on accuracy',
                        ),
                        SizedBox(height: 8),
                        Text(
                          '6. Earn XP and level up!',
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tips:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Make sure you\'re in a quiet environment'),
                        Text('• Tune your guitar before playing'),
                        Text('• Play notes clearly and let them ring'),
                        Text('• Check your weak areas in Statistics'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report a Bug'),
            subtitle: const Text('Help us improve'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bug reporting coming soon!'),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // License info
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'The Fret Journey',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Licensed under MIT License',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Made with ❤️ for guitarists',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
