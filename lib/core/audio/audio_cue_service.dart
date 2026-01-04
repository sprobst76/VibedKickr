import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Arten von Audio-Cues
enum AudioCueType {
  /// Kurzer Piepton - Countdown (3, 2, 1)
  countdown,

  /// Höherer Ton - Intervall startet
  intervalStart,

  /// Tieferer Ton - Intervall endet / Pause beginnt
  intervalEnd,

  /// Doppelter Ton - Workout komplett
  workoutComplete,
}

/// Audio Service für Training Cues
class AudioCueService {
  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  // Cached audio sources
  final Map<AudioCueType, AudioSource> _audioSources = {};

  /// Initialisiert den Audio Service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Generiere Audio-Daten für jeden Cue-Typ
      _audioSources[AudioCueType.countdown] = _createToneSource(
        frequency: 880, // A5
        durationMs: 100,
      );

      _audioSources[AudioCueType.intervalStart] = _createToneSource(
        frequency: 1320, // E6 - höher
        durationMs: 200,
      );

      _audioSources[AudioCueType.intervalEnd] = _createToneSource(
        frequency: 440, // A4 - tiefer
        durationMs: 300,
      );

      _audioSources[AudioCueType.workoutComplete] = _createDoubleToneSource(
        frequency1: 880,
        frequency2: 1320,
        durationMs: 200,
        pauseMs: 100,
      );

      _isInitialized = true;
    } catch (e) {
      // Audio nicht verfügbar - silent fail
    }
  }

  /// Spielt einen Audio Cue ab
  Future<void> playCue(AudioCueType type) async {
    if (!_isInitialized) {
      await initialize();
    }

    final source = _audioSources[type];
    if (source == null) return;

    try {
      await _player.setAudioSource(source);
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e) {
      // Silent fail - Audio nicht kritisch
    }
  }

  /// Spielt einen Countdown ab (3, 2, 1)
  Future<void> playCountdown() async {
    for (var i = 3; i > 0; i--) {
      await playCue(AudioCueType.countdown);
      await Future.delayed(const Duration(milliseconds: 900));
    }
  }

  /// Erstellt eine Audio-Source mit einem einzelnen Ton
  AudioSource _createToneSource({
    required double frequency,
    required int durationMs,
  }) {
    final wavData = _generateSineWave(
      frequency: frequency,
      durationMs: durationMs,
      sampleRate: 44100,
    );
    return _WavAudioSource(wavData);
  }

  /// Erstellt eine Audio-Source mit zwei aufeinanderfolgenden Tönen
  AudioSource _createDoubleToneSource({
    required double frequency1,
    required double frequency2,
    required int durationMs,
    required int pauseMs,
  }) {
    final tone1 = _generateSineWaveSamples(
      frequency: frequency1,
      durationMs: durationMs,
      sampleRate: 44100,
    );
    final silence = List.filled((44100 * pauseMs / 1000).round(), 0);
    final tone2 = _generateSineWaveSamples(
      frequency: frequency2,
      durationMs: durationMs,
      sampleRate: 44100,
    );

    final combined = [...tone1, ...silence, ...tone2];
    final wavData = _samplesToWav(combined, 44100);
    return _WavAudioSource(wavData);
  }

  /// Generiert eine Sinuswelle als WAV-Daten
  Uint8List _generateSineWave({
    required double frequency,
    required int durationMs,
    required int sampleRate,
  }) {
    final samples = _generateSineWaveSamples(
      frequency: frequency,
      durationMs: durationMs,
      sampleRate: sampleRate,
    );
    return _samplesToWav(samples, sampleRate);
  }

  /// Generiert Sinuswellen-Samples als 16-bit Integer
  List<int> _generateSineWaveSamples({
    required double frequency,
    required int durationMs,
    required int sampleRate,
  }) {
    final numSamples = (sampleRate * durationMs / 1000).round();
    final samples = <int>[];

    for (var i = 0; i < numSamples; i++) {
      // Sinuswelle mit Attack/Release Envelope
      final t = i / sampleRate;
      final envelope = _envelope(i, numSamples);
      final sample = sin(2 * pi * frequency * t) * envelope * 0.5;
      samples.add((sample * 32767).round().clamp(-32768, 32767));
    }

    return samples;
  }

  /// Einfaches Attack/Release Envelope
  double _envelope(int sample, int totalSamples) {
    const attackSamples = 500;
    const releaseSamples = 500;

    if (sample < attackSamples) {
      return sample / attackSamples;
    } else if (sample > totalSamples - releaseSamples) {
      return (totalSamples - sample) / releaseSamples;
    }
    return 1.0;
  }

  /// Konvertiert Samples zu WAV-Daten
  Uint8List _samplesToWav(List<int> samples, int sampleRate) {
    final byteData = ByteData(44 + samples.length * 2);

    // RIFF Header
    byteData.setUint32(0, 0x52494646, Endian.big); // "RIFF"
    byteData.setUint32(4, 36 + samples.length * 2, Endian.little);
    byteData.setUint32(8, 0x57415645, Endian.big); // "WAVE"

    // fmt chunk
    byteData.setUint32(12, 0x666D7420, Endian.big); // "fmt "
    byteData.setUint32(16, 16, Endian.little); // chunk size
    byteData.setUint16(20, 1, Endian.little); // PCM
    byteData.setUint16(22, 1, Endian.little); // mono
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * 2, Endian.little); // byte rate
    byteData.setUint16(32, 2, Endian.little); // block align
    byteData.setUint16(34, 16, Endian.little); // bits per sample

    // data chunk
    byteData.setUint32(36, 0x64617461, Endian.big); // "data"
    byteData.setUint32(40, samples.length * 2, Endian.little);

    // Audio data
    for (var i = 0; i < samples.length; i++) {
      byteData.setInt16(44 + i * 2, samples[i], Endian.little);
    }

    return byteData.buffer.asUint8List();
  }

  /// Gibt Ressourcen frei
  Future<void> dispose() async {
    await _player.dispose();
  }
}

/// StreamAudioSource für WAV-Daten
class _WavAudioSource extends StreamAudioSource {
  final Uint8List _wavData;

  _WavAudioSource(this._wavData);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _wavData.length;

    return StreamAudioResponse(
      sourceLength: _wavData.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_wavData.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}

/// Provider für den Audio Cue Service
final audioCueServiceProvider = Provider<AudioCueService>((ref) {
  final service = AudioCueService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Initialisiert den Audio Service
final audioCueInitProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(audioCueServiceProvider);
  await service.initialize();
});
