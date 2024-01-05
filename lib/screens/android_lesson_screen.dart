import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:just_audio/just_audio.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/service/backend_api_service.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:record/record.dart';

import '../main.dart';

class AndroidLessonScreen extends StatefulWidget {
  final String result;

  const AndroidLessonScreen({super.key, required this.result});

  @override
  State<AndroidLessonScreen> createState() => _AndroidLessonScreenState();
}

class _AndroidLessonScreenState extends State<AndroidLessonScreen> {
  late final YoutubePlayerController _controller;
  final _record = AudioRecorder();
  late bool _jumpingDotsVisible;
  late bool _userSuccessRateVisualizationVisible;
  late var _userAudioStream;
  bool _isPlayingAllowed = true;
  late var _videoStream;
  final AudioPlayer player = AudioPlayer();
  UserSuccessRate _userSuccessRate = UserSuccessRate(
    wordsAccuracy: 0,
    accentAccuracy: 0,
    intonationAccuracy: 0,
    pronunciationAccuracy: 0,
  );
  double _startTime = 0;
  double _stopTime = 0;

  @override
  void initState() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.result,
      autoPlay: false,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showControls: false,
      ),
    );

    _jumpingDotsVisible = false;
    _userSuccessRateVisualizationVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    _record.dispose();
    player.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  Future<void> recordAndStreamAudioToBackend() async {
    if (await _record.hasPermission()) {
      setState(() {
        _isPlayingAllowed = false;
      });

      _videoStream = await _record
          .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      _controller.playVideo();
      bool pauseOrder = await BackendApiService.backendApiServiceInstance
          .sendAudioStreamAndReceivePauseOrder(_videoStream);

      if (pauseOrder) {
        _controller.pauseVideo();
        _startTime = _stopTime;
        _stopTime = await _controller.currentTime;
        _record.pause();
        setState(() {
          _jumpingDotsVisible = true;
        });

        recordUserAudio();
      }
    }
  }

  Future<void> recordReplayAndStreamAudioToBackend() async {
    if (await _record.hasPermission()) {
      setState(() {
        _isPlayingAllowed = false;
      });

      await player.setAudioSource(MyCustomSource(_videoStream));
      player.play();

      setState(() {
        _jumpingDotsVisible = true;
      });

      recordUserAudio();
    }
  }


  Future<void> recordUserAudio() async {
    _userAudioStream = await _record
        .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    _userSuccessRate = await BackendApiService.backendApiServiceInstance
        .sendUserAudioStreamAndReceiveSuccessRate(_userAudioStream);
    setState(() {
      _isPlayingAllowed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('talk trainer',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).shadowColor,
                )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ),
          Visibility(
            visible: _jumpingDotsVisible,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Powtórz',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: JumpingDots(
                      color: AppColors.primaryBackground.shade700, radius: 15),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Theme.of(context).primaryColorDark;
                        }
                        return AppColors.primaryHighlight;
                      }),
                      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                          (Set<MaterialState> states) {
                        return Theme.of(context).textTheme.bodyMedium!;
                      }),
                    ),
                    onPressed: () {
                      setState(() {
                        _record.stop();
                        _jumpingDotsVisible = false;
                        _userSuccessRateVisualizationVisible = true;
                      });
                    },
                    child: Text(
                      'Zatwierdź',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: _userSuccessRateVisualizationVisible,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: const CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  majorGridLines: MajorGridLines(width: 0),
                ),
                series: <ColumnSeries<double, String>>[
                  ColumnSeries<double, String>(
                    dataSource: [_userSuccessRate.wordsAccuracy * 100],
                    xValueMapper: (_, int index) => 'Words',
                    yValueMapper: (double value, _) => value,
                  ),
                  ColumnSeries<double, String>(
                    dataSource: [_userSuccessRate.pronunciationAccuracy * 100],
                    xValueMapper: (_, int index) => 'Pronunciation',
                    yValueMapper: (double value, _) => value,
                  ),
                  ColumnSeries<double, String>(
                    dataSource: [_userSuccessRate.accentAccuracy * 100],
                    xValueMapper: (_, int index) => 'Accent',
                    yValueMapper: (double value, _) => value,
                  ),
                  ColumnSeries<double, String>(
                    dataSource: [_userSuccessRate.intonationAccuracy * 100],
                    xValueMapper: (_, int index) => 'Intonation',
                    yValueMapper: (double value, _) => value,
                  ),
                ],
              ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).shadowColor,
        unselectedItemColor: Theme.of(context).shadowColor,
        backgroundColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.red[500],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow, color: Colors.red[500]),
            label: 'Train',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.replay, color: Colors.red[500]),
            label: 'Retry',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            goToHomeScreen();
          }

          if (index == 1) {
            if (_isPlayingAllowed) {
              setState(() {
                _userSuccessRateVisualizationVisible = false;
              });
              recordAndStreamAudioToBackend();
            }
          }

          if (index == 2) {
            if (_isPlayingAllowed) {
              setState(() {
                _userSuccessRateVisualizationVisible = false;
              });
              recordReplayAndStreamAudioToBackend();
            }
          }
        },
      ),
    );
  }

  void goToHomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'talk trainer'),
      ),
    );
  }
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;

  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
