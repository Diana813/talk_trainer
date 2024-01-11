import 'dart:async';
import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioHelper {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/recording.acc');
  }

  Future<void> record() async {
    if (await _recorder.hasPermission()) {
      final file = await _localFile;
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacEld),
        path: file.path,
      );
    }
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
  }

  Future<void> play() async {
    final file = await _localFile;
    await _player.setVolume(100);
    await _player.setFilePath(file.path);
    await _player.play();
  }

  void dispose() {
    _player.dispose();
    _recorder.dispose();
  }
}
