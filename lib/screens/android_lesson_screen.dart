import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/service/backend_api_service.dart';
import 'package:talk_trainer/widgets/android_bottom_navigation_bar.dart';
import 'package:talk_trainer/widgets/start_fragment.dart';
import 'package:talk_trainer/widgets/user_recording_fragment.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:record/record.dart';

import '../main.dart';
import '../utils/audio_hepler.dart';
import '../widgets/translation_pop_up.dart';
import '../widgets/user_success_rate_fragment.dart';
import '../widgets/youtube_player.dart';

class AndroidLessonScreen extends StatefulWidget {
  final String result;

  const AndroidLessonScreen({super.key, required this.result});

  @override
  State<AndroidLessonScreen> createState() => _AndroidLessonScreenState();
}

class _AndroidLessonScreenState extends State<AndroidLessonScreen> {
  late final YoutubePlayerController _youtubePlayerController;
  final _recorder = AudioRecorder();
  late bool _jumpingDotsVisible;
  late bool _userSuccessRateVisualizationVisible;
  late Stream<Uint8List> _userAudioStream;
  bool _isPlayingAllowed = true;
  late Stream<Uint8List> _videoStream;
  final AudioPlayer _player = AudioPlayer();
  UserSuccessRate _userSuccessRate = UserSuccessRate(
    wordsAccuracy: 0,
    accentAccuracy: 0,
    intonationAccuracy: 0,
    pronunciationAccuracy: 0,
  );

  bool _isPlayClicked = false;

  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController.fromVideoId(
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
    _youtubePlayerController.close();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  Future<void> recordAndStreamAudioToBackend() async {
    if (await _recorder.hasPermission()) {
      setState(() {
        _isPlayingAllowed = false;
      });

      _videoStream = await _recorder
          .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      _youtubePlayerController.playVideo();
      bool pauseOrder = await BackendApiService.backendApiServiceInstance
          .sendAudioStreamAndReceivePauseOrder(_videoStream);

      if (pauseOrder) {
        _youtubePlayerController.pauseVideo();
        _recorder.pause();
        setState(() {
          _jumpingDotsVisible = true;
        });

        recordUserAudio();
      }
    }
  }

  Future<void> recordReplayAndStreamAudioToBackend() async {
    if (await _recorder.hasPermission()) {
      setState(() {
        _isPlayingAllowed = false;
      });

      await _player.setAudioSource(MyCustomSource(_videoStream));
      _player.play();

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _jumpingDotsVisible = true;
          });

          recordUserAudio();
        }
      });
    }
  }

  Future<void> recordUserAudio() async {
    _userAudioStream = await _recorder
        .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    _userSuccessRate = await BackendApiService.backendApiServiceInstance
        .sendUserAudioStreamAndReceiveSuccessRate(_userAudioStream);
    setState(() {
      _isPlayingAllowed = true;
    });
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AppYouTubePlayer(
                youtubePlayerController: _youtubePlayerController),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !_jumpingDotsVisible &&
                      !_userSuccessRateVisualizationVisible,
                  child: StartButtonFragment(
                    isPlayClicked: _isPlayClicked,
                    onPressed: () {
                      if (_isPlayingAllowed) {
                        setState(() {
                          _userSuccessRateVisualizationVisible = false;
                          _isPlayClicked = true;
                        });
                        recordAndStreamAudioToBackend();
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: _jumpingDotsVisible,
                  child: UserRecordingFragment(
                    onPressed: () {
                      setState(() {
                        _recorder.stop();
                        _jumpingDotsVisible = false;
                        _userSuccessRateVisualizationVisible = true;
                      });
                    },
                  ),
                ),
                Visibility(
                    visible: _userSuccessRateVisualizationVisible,
                    child: UserFeedbackFragment(
                      userSuccessRate: _userSuccessRate,
                      onPressedListen: () {},
                      onPressedTranslate: () {
                        showPopup(context);
                      },
                    )),
              ],
            ),
          )
        ],
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
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
