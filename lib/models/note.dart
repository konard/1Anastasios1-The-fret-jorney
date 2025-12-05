import 'dart:math';

class Note {
  final String name;
  final int fret;
  final int string; // 1 = high E, 6 = low E
  final double frequency;
  final double accuracy; // 0.0 to 1.0

  Note({
    required this.name,
    required this.fret,
    required this.string,
    required this.frequency,
    this.accuracy = 1.0,
  });

  // Standard guitar tuning: E A D G B E (from low to high)
  static const List<String> stringNotes = ['E', 'A', 'D', 'G', 'B', 'E'];
  static const List<String> noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  static const Map<String, double> noteFrequencies = {
    'C': 261.63,
    'C#': 277.18,
    'D': 293.66,
    'D#': 311.13,
    'E': 329.63,
    'F': 349.23,
    'F#': 369.99,
    'G': 392.00,
    'G#': 415.30,
    'A': 440.00,
    'A#': 466.16,
    'B': 493.88,
  };

  factory Note.random() {
    final random = Random();
    final string = random.nextInt(6) + 1; // 1-6
    final fret = random.nextInt(13); // 0-12

    // Calculate note name based on string and fret
    final stringNote = stringNotes[6 - string]; // Reverse for low to high
    final stringNoteIndex = noteNames.indexOf(stringNote);
    final noteIndex = (stringNoteIndex + fret) % 12;
    final noteName = noteNames[noteIndex];

    // Calculate approximate frequency
    final baseFreq = noteFrequencies[noteName] ?? 440.0;
    final octaveAdjust = (string <= 3) ? 1.0 : 0.5;
    final frequency = baseFreq * octaveAdjust;

    return Note(
      name: noteName,
      fret: fret,
      string: string,
      frequency: frequency,
    );
  }

  factory Note.fromFrequency(double frequency, {double accuracy = 1.0}) {
    // Find closest note
    double minDiff = double.infinity;
    String closestNote = 'A';

    for (final entry in noteFrequencies.entries) {
      final diff = (entry.value - frequency).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestNote = entry.key;
      }
    }

    return Note(
      name: closestNote,
      fret: 0,
      string: 1,
      frequency: frequency,
      accuracy: accuracy,
    );
  }

  @override
  String toString() => '$name (String: $string, Fret: $fret)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
