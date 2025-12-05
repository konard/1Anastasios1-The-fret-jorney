import 'package:flutter_test/flutter_test.dart';
import 'package:the_fret_journey/models/note.dart';

void main() {
  group('Note Model Tests', () {
    test('Note.random should generate valid note', () {
      final note = Note.random();

      expect(note.name, isNotNull);
      expect(Note.noteNames.contains(note.name), isTrue);
      expect(note.string, inInclusiveRange(1, 6));
      expect(note.fret, inInclusiveRange(0, 12));
      expect(note.frequency, greaterThan(0));
    });

    test('Note.fromFrequency should find closest note', () {
      // A4 = 440 Hz
      final note = Note.fromFrequency(440.0);
      expect(note.name, equals('A'));
    });

    test('Note.fromFrequency should handle nearby frequencies', () {
      // Close to C (261.63 Hz)
      final note = Note.fromFrequency(260.0);
      expect(note.name, equals('C'));
    });

    test('Note equality should work correctly', () {
      final note1 = Note(name: 'C', fret: 0, string: 1, frequency: 261.63);
      final note2 = Note(name: 'C', fret: 1, string: 2, frequency: 261.63);
      final note3 = Note(name: 'D', fret: 0, string: 1, frequency: 293.66);

      expect(note1, equals(note2)); // Same name
      expect(note1, isNot(equals(note3))); // Different name
    });

    test('Note.toString should include relevant info', () {
      final note = Note(name: 'C', fret: 3, string: 2, frequency: 261.63);
      final str = note.toString();

      expect(str, contains('C'));
      expect(str, contains('3'));
      expect(str, contains('2'));
    });

    test('Note frequencies map should contain all notes', () {
      expect(Note.noteFrequencies.length, equals(12));
      expect(Note.noteFrequencies.containsKey('A'), isTrue);
      expect(Note.noteFrequencies['A'], equals(440.0));
    });
  });
}
