import 'package:flutter/material.dart';
import '../models/note.dart';

class FretboardWidget extends StatelessWidget {
  final Note? targetNote;
  final Note? playedNote;
  final bool showCorrect;
  final bool showIncorrect;

  const FretboardWidget({
    super.key,
    this.targetNote,
    this.playedNote,
    this.showCorrect = false,
    this.showIncorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Fretboard header
          Text(
            'Guitar Fretboard',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Fretboard
          AspectRatio(
            aspectRatio: 2.5,
            child: CustomPaint(
              painter: FretboardPainter(
                targetNote: targetNote,
                playedNote: playedNote,
                showCorrect: showCorrect,
                showIncorrect: showIncorrect,
              ),
              child: Container(),
            ),
          ),

          const SizedBox(height: 16),

          // String labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Note.stringNotes.reversed.map((note) {
              return Text(
                note,
                style: Theme.of(context).textTheme.bodySmall,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class FretboardPainter extends CustomPainter {
  final Note? targetNote;
  final Note? playedNote;
  final bool showCorrect;
  final bool showIncorrect;

  FretboardPainter({
    this.targetNote,
    this.playedNote,
    this.showCorrect,
    this.showIncorrect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 2;

    final fretPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 3;

    final stringPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1;

    const int numFrets = 12;
    const int numStrings = 6;

    final fretWidth = size.width / (numFrets + 1);
    final stringHeight = size.height / (numStrings + 1);

    // Draw frets (vertical lines)
    for (int i = 0; i <= numFrets; i++) {
      final x = i * fretWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        fretPaint,
      );
    }

    // Draw strings (horizontal lines)
    for (int i = 1; i <= numStrings; i++) {
      final y = i * stringHeight;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        stringPaint,
      );
    }

    // Draw fret markers (dots on 3rd, 5th, 7th, 9th frets and double dots on 12th)
    final markerPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final markerFrets = [3, 5, 7, 9];
    for (final fret in markerFrets) {
      final x = (fret - 0.5) * fretWidth;
      final y = size.height / 2;
      canvas.drawCircle(Offset(x, y), 8, markerPaint);
    }

    // Double dots for 12th fret
    final x12 = (12 - 0.5) * fretWidth;
    canvas.drawCircle(Offset(x12, size.height / 3), 8, markerPaint);
    canvas.drawCircle(Offset(x12, 2 * size.height / 3), 8, markerPaint);

    // Draw target note
    if (targetNote != null) {
      final targetPaint = Paint()
        ..color = Colors.blue.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final x = (targetNote!.fret + 0.5) * fretWidth;
      final y = targetNote!.string * stringHeight;

      canvas.drawCircle(Offset(x, y), 20, targetPaint);

      // Draw note name
      final textPainter = TextPainter(
        text: TextSpan(
          text: targetNote!.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw played note feedback
    if (playedNote != null && showCorrect) {
      final correctPaint = Paint()
        ..color = Colors.green.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      final x = (targetNote?.fret ?? 0 + 0.5) * fretWidth;
      final y = (targetNote?.string ?? 1) * stringHeight;

      canvas.drawCircle(Offset(x, y), 25, correctPaint);
    }

    if (playedNote != null && showIncorrect) {
      final incorrectPaint = Paint()
        ..color = Colors.red.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      final x = (targetNote?.fret ?? 0 + 0.5) * fretWidth;
      final y = (targetNote?.string ?? 1) * stringHeight;

      canvas.drawCircle(Offset(x, y), 25, incorrectPaint);
    }
  }

  @override
  bool shouldRepaint(FretboardPainter oldDelegate) {
    return targetNote != oldDelegate.targetNote ||
        playedNote != oldDelegate.playedNote ||
        showCorrect != oldDelegate.showCorrect ||
        showIncorrect != oldDelegate.showIncorrect;
  }
}
