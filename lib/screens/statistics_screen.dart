import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_progress.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Consumer<UserProgress>(
        builder: (context, progress, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Overall stats card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Progress',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow(
                        context,
                        'Current Level',
                        '${progress.level}',
                      ),
                      _buildStatRow(
                        context,
                        'Total XP',
                        '${progress.xp}',
                      ),
                      _buildStatRow(
                        context,
                        'Total Attempts',
                        '${progress.totalAttempts}',
                      ),
                      _buildStatRow(
                        context,
                        'Correct Answers',
                        '${progress.totalCorrectAnswers}',
                      ),
                      _buildStatRow(
                        context,
                        'Overall Accuracy',
                        '${progress.overallAccuracy.toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Level progress card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level Progress',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress.levelProgress,
                        minHeight: 20,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${progress.xp} / ${progress.xpForNextLevel} XP to Level ${progress.level + 1}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weakest notes card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Areas for Improvement',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      if (progress.getWeakestNotes().isEmpty)
                        const Text('No data yet. Start training to see your weak areas!')
                      else
                        ...progress.getWeakestNotes().map((entry) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                entry.key,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('Note ${entry.key}'),
                            trailing: Text(
                              '${entry.value.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Note accuracy card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note Performance',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      if (progress.noteAccuracy.isEmpty)
                        const Text('No data yet. Start training to track your progress!')
                      else
                        ...progress.noteAccuracy.entries.map((entry) {
                          final attempts = progress.totalAttempts > 0
                              ? progress.totalAttempts
                              : 1;
                          final accuracy = (entry.value / attempts) * 100;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                entry.key,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('Note ${entry.key}'),
                            subtitle: LinearProgressIndicator(
                              value: accuracy / 100,
                              backgroundColor: Colors.grey[300],
                            ),
                            trailing: Text(
                              '${accuracy.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
