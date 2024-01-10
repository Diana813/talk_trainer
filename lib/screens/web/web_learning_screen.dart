import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:talk_trainer/models/search_response_model.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import 'package:talk_trainer/utils/youtube_search_dummy_data.dart';
import 'package:talk_trainer/fragments/lesson_fragment.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../main.dart';
import '../../models/user_success_rate.dart';
import '../../service/backend_api_service.dart';
import '../../service/youtube_api_service.dart';
import '../../utils/audio_helper.dart';
import '../../widgets/search_results_widget.dart';

class WebLearningScreen extends StatefulWidget {
  final String keywords;

  const WebLearningScreen({super.key, required this.keywords});

  @override
  _WebLearningScreenState createState() => _WebLearningScreenState();
}

class _WebLearningScreenState extends State<WebLearningScreen> {
  late Future<List<SearchResult>> _videos;
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
    _youtubePlayerController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        enableCaption: false,
        showControls: false,
      ),
    );

    _videos = YouTubeApiService.youTubeApiServiceInstance
        .fetchDummyData(dummySearchResultsLearningScreenData);
    //todo - zamienić na prawdziwą metodę
    //YouTubeApiService.youTubeApiServiceInstance.fetchVideos(keywords: widget.keywords);

    _videos
        .then((value) => _youtubePlayerController.loadVideoById(
            videoId: value.first.id.videoId))
        .then((value) => _youtubePlayerController.stopVideo());

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
        backgroundColor: AppColors.white,
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 10,
              child: LessonFragment(
                youtubePlayerController: _youtubePlayerController,
                jumpingDotsVisible: _jumpingDotsVisible,
                userSuccessRateVisualizationVisible:
                    _userSuccessRateVisualizationVisible,
                isPlayClicked: _isPlayClicked,
                onStartPressed: () {
                  if (_isPlayingAllowed) {
                    setState(() {
                      _userSuccessRateVisualizationVisible = false;
                      _isPlayClicked = true;
                    });
                    recordAndStreamAudioToBackend();
                  }
                },
                onUserRecordingSubmitPressed: () {
                  setState(() {
                    _recorder.stop();
                    _jumpingDotsVisible = false;
                    _userSuccessRateVisualizationVisible = true;
                  });
                },
                userSuccessRate: _userSuccessRate,
              ),
            ),
            Expanded(flex: 5, child: SearchResultsWidget(videos: _videos)),
          ]),
    );
  }
}
