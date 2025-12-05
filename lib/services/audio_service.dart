import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import '../models/note.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final PitchDetector _pitchDetector = PitchDetector(44100, 2048);

  bool _isRecording = false;
  bool _isInitialized = false;

  bool get isRecording => _isRecording;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return false;
      }

      // Initialize recorder
      await _recorder.openRecorder();
      _isInitialized = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> startListening(Function(Note) onNoteDetected) async {
    if (!_isInitialized || _isRecording) return;

    try {
      _isRecording = true;

      await _recorder.startRecorder(
        toStream: _processAudioData(onNoteDetected),
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 44100,
      );
    } catch (e) {
      _isRecording = false;
      rethrow;
    }
  }

  StreamSink<List<int>> _processAudioData(Function(Note) onNoteDetected) {
    return StreamController<List<int>>.broadcast(
      onListen: () {},
    ).sink;
  }

  Future<Note?> detectPitch(List<double> audioBuffer) async {
    try {
      final result = _pitchDetector.getPitch(audioBuffer);

      if (result.pitch > 0) {
        final note = Note.fromFrequency(
          result.pitch,
          accuracy: result.probability,
        );
        return note;
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  Future<void> stopListening() async {
    if (!_isRecording) return;

    try {
      await _recorder.stopRecorder();
      _isRecording = false;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> dispose() async {
    if (_isRecording) {
      await stopListening();
    }
    if (_isInitialized) {
      await _recorder.closeRecorder();
      _isInitialized = false;
    }
  }
}
