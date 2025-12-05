import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/user_progress.dart';
import '../services/audio_service.dart';
import '../widgets/fretboard_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioService _audioService = AudioService();
  bool _isInitialized = false;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final success = await _audioService.initialize();
    setState(() {
      _isInitialized = success;
      _statusMessage = success
          ? 'Ready to play!'
          : 'Microphone permission required';
    });

    if (success) {
      // Generate first note
      Provider.of<GameState>(context, listen: false).generateNewNote();
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _startListening() async {
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.setListening(true);

    await _audioService.startListening((note) {
      gameState.checkAnswer(note);

      // Award XP
      final userProgress = Provider.of<UserProgress>(context, listen: false);
      if (gameState.lastResult == 'correct') {
        final xpAmount = (note.accuracy * 100).toInt();
        userProgress.addXP(xpAmount, noteName: note.name, correct: true);

        // Generate new note after short delay
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            gameState.generateNewNote();
            gameState.setListening(false);
          }
        });
      } else {
        userProgress.addXP(0, noteName: note.name, correct: false);
        gameState.setListening(false);
      }
    });
  }

  void _stopListening() async {
    await _audioService.stopListening();
    Provider.of<GameState>(context, listen: false).setListening(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        actions: [
          Consumer<GameState>(
            builder: (context, gameState, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${gameState.correctAnswers}/${gameState.totalAttempts}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: !_isInitialized
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(_statusMessage),
                ],
              ),
            )
          : Consumer<GameState>(
              builder: (context, gameState, child) {
                return Column(
                  children: [
                    // Current level and XP
                    Consumer<UserProgress>(
                      builder: (context, progress, child) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Level ${progress.level}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                'XP: ${progress.xp}/${progress.xpForNextLevel}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Target note display
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'Play this note:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                gameState.currentNote?.name ?? '?',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Fretboard
                    Expanded(
                      child: FretboardWidget(
                        targetNote: gameState.currentNote,
                        showCorrect: gameState.lastResult == 'correct',
                        showIncorrect: gameState.lastResult == 'incorrect',
                      ),
                    ),

                    // Status and accuracy
                    if (gameState.lastResult.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: gameState.lastResult == 'correct'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              gameState.lastResult == 'correct'
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: gameState.lastResult == 'correct'
                                  ? Colors.green
                                  : Colors.red,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              gameState.lastResult == 'correct'
                                  ? 'Correct! Accuracy: ${(gameState.accuracy * 100).toStringAsFixed(1)}%'
                                  : 'Try again!',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),

                    // Listen button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: gameState.isListening ? null : _startListening,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: Text(
                          gameState.isListening
                              ? '🎤 Listening...'
                              : '🎤 Tap to Play',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
