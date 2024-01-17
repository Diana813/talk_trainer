import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/service/backend_api_service.dart';
import 'package:talk_trainer/utils/youtube_helper.dart';
import 'package:talk_trainer/widgets/android_bottom_navigation_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../main.dart';
import '../../fragments/lesson_fragment.dart';
import '../../models/timestamps_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/audio_helper.dart';

class AndroidLessonScreen extends StatefulWidget {
  final String result;

  const AndroidLessonScreen({super.key, required this.result});

  @override
  State<AndroidLessonScreen> createState() => _AndroidLessonScreenState();
}

class _AndroidLessonScreenState extends State<AndroidLessonScreen> {
  late final YoutubePlayerController _youtubePlayerController;
  late final YoutubePlayerHelper _youtubePlayerHelper;
  late AudioHelper _audioHelper;
  late List<Timestamp> _pausesTimestamps;
  late String _videoUrl;
  late VideoPlayerController _videoPlayerController;
  late Future<List<dynamic>> dataFuture;

  bool _isPlayClicked = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool pauseOrder = false;

  int _pauseTimeIndex = 0;
  int _startVideo = 0;
  int _stopVideo = 0;

  int _selectedIndex = 0;

  UserSuccessRate _userSuccessRate = UserSuccessRate(
    wordsAccuracy: 0,
    accentAccuracy: 0,
    intonationAccuracy: 0,
    pronunciationAccuracy: 0,
  );

  @override
  void initState() {
    _audioHelper = AudioHelper();

    dataFuture = Future.wait([
      BackendApiService.backendApiServiceInstance
          .fetchVideoUrl('https://www.youtube.com/watch?v=48jlHaxZnig'),
      BackendApiService.backendApiServiceInstance
          .fetchTimestamps('https://www.youtube.com/watch?v=48jlHaxZnig')
    ]);

    dataFuture.then((results) {
      if (results.isNotEmpty) {
        _videoUrl =
            'http://10.0.2.2:5000/api/video?youtube_url=https://www.youtube.com/watch?v=48jlHaxZnig';
        _pausesTimestamps = results[1] as List<Timestamp>;
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(_videoUrl))
              ..initialize().then((_) {
                setState(() {});
                _youtubePlayerHelper =
                    YoutubePlayerHelper(_videoPlayerController);
                listenForMomentsToPauseVideo();
              });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.close();
    _audioHelper.dispose();
    _youtubePlayerHelper.dispose();
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void listenForMomentsToPauseVideo() async {
    List<int> sortedTimestamps = _pausesTimestamps
        .map((value) => value.millis.truncate())
        .toList()
      ..sort();

    _youtubePlayerHelper.startMonitoringPauseTimes(sortedTimestamps);

    _youtubePlayerHelper.currentTimeStream.listen((event) async {
      if (event) {
        await _videoPlayerController.pause();
        var pauseTime = await _videoPlayerController.position;
        print('stopped at: ${pauseTime?.inMilliseconds}');
        setState(() {
          _isPlaying = false;
          _isPaused = true;
          _pauseTimeIndex++;
        });

        recordUserAudio();
      }
    });
  }

  Future<void> playVideoSegment() async {
    await _videoPlayerController.play();
    if (_pauseTimeIndex < _pausesTimestamps.length) {
      _startVideo = _pausesTimestamps[_pauseTimeIndex].millis.truncate();
      _stopVideo = _pausesTimestamps[_pauseTimeIndex + 1].millis.truncate();
    }

    setState(() {
      print('startVideo: $_startVideo');
      _isPlaying = true;
      _isPaused = false;
    });
  }

  Future<void> replayVideoSegment() async {
    await _videoPlayerController.seekTo(Duration(milliseconds: _startVideo));

    await _videoPlayerController.play();
    print('start v: $_startVideo');
    print('current start time: ${await _videoPlayerController.position}');
    setState(() {
      _isPlaying = true;
    });

    print('duration: ${_stopVideo - _startVideo}');
    await Future.delayed(Duration(milliseconds: _stopVideo - _startVideo));

    await _videoPlayerController.pause();
    setState(() {
      _isPlaying = false;
    });
    recordUserAudio();
  }

  Future<void> recordUserAudio() async {
    _audioHelper.record();
    setState(() {
      _isRecording = true;
    });

    //todo send to backend
    _userSuccessRate =
        await BackendApiService.backendApiServiceInstance.getSuccessRate();

    setState(() {});
  }

  void goToHomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'talk trainer'),
      ),
    );
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
      body: FutureBuilder<List<dynamic>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Text(
                    'Dzielę film na fragmenty do powtórzenia',
                  ),
                ),
                CircularProgressIndicator(
                  color: AppColors.secondaryMedium,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Brak danych');
          } else {
            return LessonFragment(
              controller: _videoPlayerController,
              jumpingDotsVisible: _isPaused && _isRecording,
              userSuccessRateVisualizationVisible: !_isRecording && _isPaused,
              isPlayClicked: _isPlayClicked,
              onStartPressed: () {
                if (!_isRecording && !_isPlaying && !_isPlayClicked) {
                  setState(() {
                    _isPlayClicked = true;
                  });
                  playVideoSegment();
                }
              },
              onUserRecordingSubmitPressed: () {
                _audioHelper.stopRecording();
                setState(() {
                  _isRecording = false;
                });
              },
              userSuccessRate: _userSuccessRate,
              onListenPressed: () async {
                String _userAudioUrl = await BackendApiService
                    .backendApiServiceInstance
                    .fetchUserAudioUrl();
                _audioHelper.play(_userAudioUrl);
              },
            );
          }
        },
      ),
      bottomNavigationBar: AndroidBottomNavigationBar(
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            goToHomeScreen();
          }

          if (index == 1) {
            if (!_isRecording && !_isPlaying) {
              setState(() {
                _isPlayClicked = true;
              });
              playVideoSegment();
            }
          }

          if (index == 2) {
            if (!_isRecording && !_isPlaying) {
              replayVideoSegment();
            }
          }
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
