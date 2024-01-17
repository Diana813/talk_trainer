import 'dart:async';

import 'package:video_player/video_player.dart';

class YoutubePlayerHelper {
  final VideoPlayerController _controller;
  final _streamController = StreamController<bool>();
  Timer? _timer;

  YoutubePlayerHelper(this._controller);

  void startMonitoringPauseTimes(List<int> stopTimes) async {
    int nextTimestampIndex = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      var currentTime = await _controller.position;

      if (currentTime!.inMilliseconds >= (stopTimes[nextTimestampIndex] - 50)) {
        _streamController.add(true);
        nextTimestampIndex++;
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }

  Stream<bool> get currentTimeStream => _streamController.stream;
}
