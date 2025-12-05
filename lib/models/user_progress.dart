import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgress extends ChangeNotifier {
  int _level = 1;
  int _xp = 0;
  int _totalCorrectAnswers = 0;
  int _totalAttempts = 0;
  Map<String, int> _noteAccuracy = {};

  int get level => _level;
  int get xp => _xp;
  int get totalCorrectAnswers => _totalCorrectAnswers;
  int get totalAttempts => _totalAttempts;
  Map<String, int> get noteAccuracy => _noteAccuracy;

  // XP needed for next level
  int get xpForNextLevel => _level * 100;

  // Progress to next level (0.0 to 1.0)
  double get levelProgress => _xp / xpForNextLevel;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt('level') ?? 1;
    _xp = prefs.getInt('xp') ?? 0;
    _totalCorrectAnswers = prefs.getInt('totalCorrectAnswers') ?? 0;
    _totalAttempts = prefs.getInt('totalAttempts') ?? 0;

    // Load note accuracy
    final keys = prefs.getKeys().where((key) => key.startsWith('note_'));
    for (final key in keys) {
      final noteName = key.substring(5);
      _noteAccuracy[noteName] = prefs.getInt(key) ?? 0;
    }

    notifyListeners();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', _level);
    await prefs.setInt('xp', _xp);
    await prefs.setInt('totalCorrectAnswers', _totalCorrectAnswers);
    await prefs.setInt('totalAttempts', _totalAttempts);

    // Save note accuracy
    for (final entry in _noteAccuracy.entries) {
      await prefs.setInt('note_${entry.key}', entry.value);
    }
  }

  void addXP(int amount, {String? noteName, bool correct = true}) {
    _xp += amount;
    _totalAttempts++;

    if (correct) {
      _totalCorrectAnswers++;
      if (noteName != null) {
        _noteAccuracy[noteName] = (_noteAccuracy[noteName] ?? 0) + 1;
      }
    }

    // Check for level up
    while (_xp >= xpForNextLevel) {
      _xp -= xpForNextLevel;
      _level++;
    }

    saveProgress();
    notifyListeners();
  }

  double get overallAccuracy {
    if (_totalAttempts == 0) return 0.0;
    return (_totalCorrectAnswers / _totalAttempts) * 100;
  }

  List<MapEntry<String, double>> getWeakestNotes() {
    if (_noteAccuracy.isEmpty) return [];

    final sorted = _noteAccuracy.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted.take(3).map((e) {
      final attempts = _totalAttempts > 0 ? _totalAttempts : 1;
      final accuracy = (e.value / attempts) * 100;
      return MapEntry(e.key, accuracy);
    }).toList();
  }
}
