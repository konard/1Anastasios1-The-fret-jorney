import 'package:flutter_test/flutter_test.dart';
import 'package:the_fret_journey/models/user_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserProgress Tests', () {
    late UserProgress userProgress;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      userProgress = UserProgress();
    });

    test('Initial state should be correct', () {
      expect(userProgress.level, equals(1));
      expect(userProgress.xp, equals(0));
      expect(userProgress.totalCorrectAnswers, equals(0));
      expect(userProgress.totalAttempts, equals(0));
      expect(userProgress.noteAccuracy, isEmpty);
    });

    test('xpForNextLevel should calculate correctly', () {
      expect(userProgress.xpForNextLevel, equals(100)); // Level 1

      userProgress.addXP(100, correct: true);
      expect(userProgress.level, equals(2));
      expect(userProgress.xpForNextLevel, equals(200)); // Level 2
    });

    test('levelProgress should calculate correctly', () {
      expect(userProgress.levelProgress, equals(0.0));

      userProgress.addXP(50, correct: true);
      expect(userProgress.levelProgress, closeTo(0.5, 0.01));

      userProgress.addXP(50, correct: true);
      expect(userProgress.level, equals(2));
      expect(userProgress.levelProgress, equals(0.0)); // New level
    });

    test('addXP should update stats correctly', () {
      userProgress.addXP(50, noteName: 'C', correct: true);

      expect(userProgress.xp, equals(50));
      expect(userProgress.totalAttempts, equals(1));
      expect(userProgress.totalCorrectAnswers, equals(1));
      expect(userProgress.noteAccuracy['C'], equals(1));
    });

    test('addXP should handle incorrect answers', () {
      userProgress.addXP(0, noteName: 'C', correct: false);

      expect(userProgress.xp, equals(0));
      expect(userProgress.totalAttempts, equals(1));
      expect(userProgress.totalCorrectAnswers, equals(0));
      expect(userProgress.noteAccuracy['C'], isNull);
    });

    test('addXP should trigger level up', () {
      expect(userProgress.level, equals(1));

      userProgress.addXP(100, correct: true);
      expect(userProgress.level, equals(2));
      expect(userProgress.xp, equals(0)); // XP resets

      userProgress.addXP(200, correct: true);
      expect(userProgress.level, equals(3));
      expect(userProgress.xp, equals(0));
    });

    test('addXP should handle multiple level ups', () {
      userProgress.addXP(350, correct: true); // 100 + 200 + 50 remaining

      expect(userProgress.level, equals(3));
      expect(userProgress.xp, equals(50));
    });

    test('overallAccuracy should calculate correctly', () {
      expect(userProgress.overallAccuracy, equals(0.0));

      userProgress.addXP(50, correct: true);
      userProgress.addXP(50, correct: true);
      userProgress.addXP(0, correct: false);

      expect(userProgress.overallAccuracy, closeTo(66.67, 0.01));
    });

    test('getWeakestNotes should return empty for no data', () {
      expect(userProgress.getWeakestNotes(), isEmpty);
    });

    test('getWeakestNotes should return sorted notes', () {
      userProgress.addXP(10, noteName: 'C', correct: true);
      userProgress.addXP(10, noteName: 'C', correct: true);
      userProgress.addXP(10, noteName: 'D', correct: true);
      userProgress.addXP(10, noteName: 'E', correct: true);
      userProgress.addXP(10, noteName: 'E', correct: true);
      userProgress.addXP(10, noteName: 'E', correct: true);

      final weakest = userProgress.getWeakestNotes();
      expect(weakest.length, lessThanOrEqualTo(3));
      expect(weakest.first.key, equals('D')); // Lowest count
    });

    test('saveProgress and loadProgress should work', () async {
      userProgress.addXP(150, noteName: 'C', correct: true);

      await userProgress.saveProgress();

      final newProgress = UserProgress();
      await newProgress.loadProgress();

      expect(newProgress.level, equals(userProgress.level));
      expect(newProgress.xp, equals(userProgress.xp));
      expect(newProgress.totalAttempts, equals(userProgress.totalAttempts));
      expect(
        newProgress.totalCorrectAnswers,
        equals(userProgress.totalCorrectAnswers),
      );
    });
  });
}
