import 'package:flutter/foundation.dart';
import 'note.dart';

class GameState extends ChangeNotifier {
  Note? _currentNote;
  int _correctAnswers = 0;
  int _totalAttempts = 0;
  bool _isListening = false;
  double _accuracy = 0.0;
  String _lastResult = '';

  Note? get currentNote => _currentNote;
  int get correctAnswers => _correctAnswers;
  int get totalAttempts => _totalAttempts;
  bool get isListening => _isListening;
  double get accuracy => _accuracy;
  String get lastResult => _lastResult;

  void generateNewNote() {
    _currentNote = Note.random();
    notifyListeners();
  }

  void setListening(bool listening) {
    _isListening = listening;
    notifyListeners();
  }

  void checkAnswer(Note playedNote) {
    _totalAttempts++;

    if (_currentNote != null && playedNote.name == _currentNote!.name) {
      _correctAnswers++;
      _accuracy = playedNote.accuracy;
      _lastResult = 'correct';
    } else {
      _lastResult = 'incorrect';
    }

    notifyListeners();
  }

  void reset() {
    _correctAnswers = 0;
    _totalAttempts = 0;
    _accuracy = 0.0;
    _lastResult = '';
    _currentNote = null;
    notifyListeners();
  }

  double get successRate {
    if (_totalAttempts == 0) return 0.0;
    return (_correctAnswers / _totalAttempts) * 100;
  }
}
