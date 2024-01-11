import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/service/backend_api_service.dart';
import 'package:talk_trainer/widgets/android_bottom_navigation_bar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../main.dart';
import '../../fragments/lesson_fragment.dart';
import '../../utils/audio_helper.dart';

class AndroidLessonScreen extends StatefulWidget {
  final String result;

  const AndroidLessonScreen({super.key, required this.result});

  @override
  State<AndroidLessonScreen> createState() => _AndroidLessonScreenState();
}

class _AndroidLessonScreenState extends State<AndroidLessonScreen> {
  late final YoutubePlayerController _youtubePlayerController;
  late AudioHelper _audioHelper;

  bool _isPlayClicked = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isPaused = false;

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

    _youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: widget.result,
      autoPlay: false,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showControls: false,
      ),
    );

    monitorTimestamps();

    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.close();
    _audioHelper.dispose();
    super.dispose();
  }

  void monitorTimestamps() {
    _youtubePlayerController.listen((event) async {
      if (event.playerState == PlayerState.paused ||
          event.playerState == PlayerState.ended) {
        double stopInSeconds = await _youtubePlayerController.currentTime;

        setState(() {
          _stopVideo = (stopInSeconds * 1000).ceil();
          print('stopVideo: $_stopVideo');
        });
      }
    });
  }

  Future<void> recordAndStreamAudioToBackend() async {
    await _audioHelper.record();
    await _youtubePlayerController.playVideo();
    double startInSeconds = await _youtubePlayerController.currentTime;

    setState(() {
      _startVideo = (startInSeconds * 1000).ceil();
      print('startVideo: $_startVideo');
      _isRecording = true;
      _isPlaying = true;
      _isPaused = false;
    });

    //todo stream to backend
    bool pauseOrder = await BackendApiService.backendApiServiceInstance
        .sendAudioStreamAndReceivePauseOrder();

    if (pauseOrder) {
      await _audioHelper.stopRecording();
      await _youtubePlayerController.pauseVideo();
      setState(() {
        _isRecording = false;
        _isPlaying = false;
        _isPaused = true;
      });

      recordUserAudio();
    }
  }

  Future<void> recordReplayAndStreamAudioToBackend() async {
    await _youtubePlayerController.seekTo(
        seconds: _startVideo / 1000, allowSeekAhead: true);

    await _youtubePlayerController.playVideo();
    print('start v: $_startVideo');
    print('current start time: ${await _youtubePlayerController.currentTime}');
    setState(() {
      _isPlaying = true;
    });

    print('duration: ${_stopVideo - _startVideo}');
    await Future.delayed(Duration(milliseconds: _stopVideo - _startVideo));

    await _youtubePlayerController.pauseVideo();
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
    _userSuccessRate = await BackendApiService.backendApiServiceInstance
        .sendUserAudioStreamAndReceiveSuccessRate();

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
      body: LessonFragment(
        youtubePlayerController: _youtubePlayerController,
        jumpingDotsVisible: _isPaused && _isRecording,
        userSuccessRateVisualizationVisible: !_isRecording && _isPaused,
        isPlayClicked: _isPlayClicked,
        onStartPressed: () {
          if (!_isRecording && !_isPlaying && !_isPlayClicked) {
            setState(() {
              _isPlayClicked = true;
            });
            recordAndStreamAudioToBackend();
          }
        },
        onUserRecordingSubmitPressed: () {
          _audioHelper.stopRecording();
          setState(() {
            _isRecording = false;
          });
        },
        userSuccessRate: _userSuccessRate,
        onListenPressed: () {
          _audioHelper.play();
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
              recordAndStreamAudioToBackend();
            }
          }

          if (index == 2) {
            if (!_isRecording && !_isPlaying) {
              recordReplayAndStreamAudioToBackend();
            }
          }
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
