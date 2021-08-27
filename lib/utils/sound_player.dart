import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart' show Level;

class SoundPlayer {
  var _isInitialized = false;

  FlutterSoundPlayer _player = FlutterSoundPlayer(logLevel: Level.error);

  bool get isPlaying {
    return _player.isPlaying;
  }

  bool get isPaused {
    return _player.isPaused;
  }

  Stream<PlaybackDisposition>? get progress {
    return _player.onProgress;
  }

  Future<void> init() async {
    await _player.openAudioSession();
    await _player.setSubscriptionDuration(Duration(seconds: 1));

    _isInitialized = true;
  }

  void dispose() {
    _player.closeAudioSession();
    _isInitialized = false;
  }

  void start(File file, Function()? onComplete) async {
    if (!_isInitialized) return;

    await _player.startPlayer(fromURI: file.path, whenFinished: onComplete);
  }

  void resume() async {
    if (_isInitialized) {
      await _player.resumePlayer();
    }
  }

  void pause() async {
    if (_isInitialized) {
      await _player.pausePlayer();
    }
  }

  void stop() async {
    if (_isInitialized) {
      _player.stopPlayer();
    }
  }
}
