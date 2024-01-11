/*
import 'dart:async';

import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class YoutubePlayerHelper {
  final YoutubePlayerController _controller;
  final _streamController = StreamController<bool>();
  Timer? _timer;

  YoutubePlayerHelper(this._controller);

  void startMonitoring(int stopTime) async {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      var currentTime = await _controller.value.position;
      print('current $currentTime');
      print('stop $stopTime');

      if (currentTime.inMilliseconds >= stopTime) {
        stopMonitoring();
        _streamController.add(true);
      }
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
    _streamController.close();
  }

  Stream<bool> get currentTimeStream => _streamController.stream;
}
*/
