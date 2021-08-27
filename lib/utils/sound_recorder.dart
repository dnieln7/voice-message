import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart' show Level;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  final _path = 'recording.mp4';
  var _isInitialized = false;

  FlutterSoundRecorder? _recorder;

  bool get isRecording {
    return _recorder == null ? false : _recorder!.isRecording;
  }

  Stream<RecordingDisposition>? get progress {
    return _recorder != null ? _recorder!.onProgress : null;
  }

  void init() async {
    _recorder = FlutterSoundRecorder(logLevel: Level.error);

    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission is needed');
    }

    await _recorder?.openAudioSession();

    _isInitialized = true;
  }

  void dispose() {
    _recorder?.closeAudioSession();
    _recorder = null;
    _isInitialized = false;
  }

  void start() async {
    if (!_isInitialized) return;

    await _recorder?.startRecorder(toFile: _path);
  }

  void stopWithoutSaving() async {
    if (_isInitialized) {
      final uri = await _recorder?.stopRecorder();

      if (uri != null) {
        final file = File(uri);

        await file.delete(recursive: false);
      }
    }
  }

  Future<File?> stop() async {
    if (_isInitialized) {
      final uri = await _recorder?.stopRecorder();

      if (uri != null) {
        final file = await _saveToExternal(uri);

        return file;
      }
    }

    return null;
  }

  Future<File> _saveToExternal(String uri) async {
    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var mp3Path = tempPath + '/recording.mp3';

    await FlutterSoundHelper().convertFile(
      uri,
      Codec.aacMP4,
      mp3Path,
      Codec.mp3,
    );

    final recording = File(mp3Path);

    final Directory? dir = await getExternalStorageDirectory();
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.mp3";
    final savedRecording = await recording.copy('${dir!.path}/$fileName');

    return savedRecording;
  }
}
