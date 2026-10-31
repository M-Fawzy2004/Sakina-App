import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/errors/exceptions.dart';

abstract interface class AudioPlayerHandler {
  Stream<PlayerState> get playerStateStream;
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<double> get volumeStream;

  bool get isPlaying;
  Duration get currentPosition;

  Future<void> setAudioUrl(String url);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
  Future<void> duckVolumeAndPause();
  Future<void> dispose();
}

class AudioPlayerHandlerImpl implements AudioPlayerHandler {
  final AudioPlayer _player;

  AudioPlayerHandlerImpl({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<double> get volumeStream => _player.volumeStream;

  @override
  bool get isPlaying => _player.playing;

  @override
  Duration get currentPosition => _player.position;

  @override
  Future<void> setAudioUrl(String url) async {
    try {
      await _player.setUrl(url);
    } catch (e) {
      throw AudioPlaybackException(message: 'فشل تحميل المقطع الصوتي: $e');
    }
  }

  @override
  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      throw AudioPlaybackException(message: 'فشل تشغيل الصوت: $e');
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      throw AudioPlaybackException(message: 'فشل إيقاف الصوت مؤقتاً: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      throw AudioPlaybackException(message: 'فشل إيقاف الصوت: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      throw AudioPlaybackException(message: 'فشل الانتقال لموضع الصوت: $e');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  @override
  Future<void> setSpeed(double speed) async {
    try {
      await _player.setSpeed(speed.clamp(0.5, 2.5));
    } catch (e) {
      throw AudioPlaybackException(message: 'فشل ضبط سرعة التلاوة: $e');
    }
  }

  /// Gradually ducks volume over 15 seconds before pausing smoothly.
  @override
  Future<void> duckVolumeAndPause() async {
    const steps = 15;
    final initialVolume = _player.volume;
    final stepDuration = Duration(
      milliseconds: AppConstants.sleepTimerDuckingDuration.inMilliseconds ~/ steps,
    );

    for (int i = steps; i >= 0; i--) {
      if (!_player.playing) break;
      await _player.setVolume(initialVolume * (i / steps));
      await Future.delayed(stepDuration);
    }

    await pause();
    await _player.setVolume(initialVolume);
  }

  @override
  Future<void> dispose() async {
    await _player.stop();
    await _player.dispose();
  }
}

