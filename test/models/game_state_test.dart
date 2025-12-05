import 'package:flutter_test/flutter_test.dart';
import 'package:the_fret_journey/models/game_state.dart';
import 'package:the_fret_journey/models/note.dart';

void main() {
  group('GameState Tests', () {
    late GameState gameState;

    setUp(() {
      gameState = GameState();
    });

    test('Initial state should be correct', () {
      expect(gameState.currentNote, isNull);
      expect(gameState.correctAnswers, equals(0));
      expect(gameState.totalAttempts, equals(0));
      expect(gameState.isListening, isFalse);
      expect(gameState.accuracy, equals(0.0));
      expect(gameState.lastResult, isEmpty);
    });

    test('generateNewNote should create a note', () {
      gameState.generateNewNote();
      expect(gameState.currentNote, isNotNull);
    });

    test('setListening should update listening state', () {
      expect(gameState.isListening, isFalse);

      gameState.setListening(true);
      expect(gameState.isListening, isTrue);

      gameState.setListening(false);
      expect(gameState.isListening, isFalse);
    });

    test('checkAnswer should update stats correctly for correct answer', () {
      gameState.generateNewNote();
      final currentNote = gameState.currentNote!;

      final playedNote = Note(
        name: currentNote.name,
        fret: 0,
        string: 1,
        frequency: 440.0,
        accuracy: 0.95,
      );

      gameState.checkAnswer(playedNote);

      expect(gameState.totalAttempts, equals(1));
      expect(gameState.correctAnswers, equals(1));
      expect(gameState.lastResult, equals('correct'));
      expect(gameState.accuracy, equals(0.95));
    });

    test('checkAnswer should update stats correctly for incorrect answer', () {
      gameState.generateNewNote();

      final playedNote = Note(
        name: 'X', // Invalid note
        fret: 0,
        string: 1,
        frequency: 440.0,
      );

      gameState.checkAnswer(playedNote);

      expect(gameState.totalAttempts, equals(1));
      expect(gameState.correctAnswers, equals(0));
      expect(gameState.lastResult, equals('incorrect'));
    });

    test('successRate should calculate correctly', () {
      gameState.generateNewNote();
      final currentNote = gameState.currentNote!;

      // 2 correct answers
      gameState.checkAnswer(Note(
        name: currentNote.name,
        fret: 0,
        string: 1,
        frequency: 440.0,
      ));

      gameState.generateNewNote();
      final newNote = gameState.currentNote!;

      gameState.checkAnswer(Note(
        name: newNote.name,
        fret: 0,
        string: 1,
        frequency: 440.0,
      ));

      // 1 incorrect answer
      gameState.generateNewNote();
      gameState.checkAnswer(Note(
        name: 'X',
        fret: 0,
        string: 1,
        frequency: 440.0,
      ));

      expect(gameState.successRate, closeTo(66.67, 0.01));
    });

    test('reset should clear all state', () {
      gameState.generateNewNote();
      gameState.setListening(true);
      gameState.checkAnswer(Note(
        name: 'C',
        fret: 0,
        string: 1,
        frequency: 440.0,
      ));

      gameState.reset();

      expect(gameState.currentNote, isNull);
      expect(gameState.correctAnswers, equals(0));
      expect(gameState.totalAttempts, equals(0));
      expect(gameState.accuracy, equals(0.0));
      expect(gameState.lastResult, isEmpty);
    });
  });
}
