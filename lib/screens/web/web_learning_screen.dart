import 'package:flutter/material.dart';
import 'package:talk_trainer/fragments/web_bottom_navigation.dart';
import 'package:talk_trainer/models/search_response_model.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import 'package:talk_trainer/utils/youtube_search_dummy_data.dart';
import 'package:talk_trainer/fragments/lesson_fragment.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  late AudioHelper _audioHelper;

  bool _isPlayClicked = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isPaused = false;

  int _startVideo = 0;
  int _stopVideo = 0;

  UserSuccessRate _userSuccessRate = UserSuccessRate(
    wordsAccuracy: 0,
    accentAccuracy: 0,
    intonationAccuracy: 0,
    pronunciationAccuracy: 0,
  );

  @override
  void initState() {
    _audioHelper = AudioHelper();

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
    setState(() {
      _isPlaying = true;
    });

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 5,
                    child: LessonFragment(
                      youtubePlayerController: _youtubePlayerController,
                      jumpingDotsVisible: _isPaused && _isRecording,
                      userSuccessRateVisualizationVisible:
                          !_isRecording && _isPaused,
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
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: WebBottomNavigationFragment(
                      onListenPressed: () {
                        _audioHelper.play();
                      },
                      onStartPressed: () {
                        if (!_isRecording && !_isPlaying) {
                          setState(() {
                            _isPlayClicked = true;
                          });
                          recordAndStreamAudioToBackend();
                        }
                      },
                      onReplyPressed: () {
                        if (!_isRecording && !_isPlaying) {
                          recordReplayAndStreamAudioToBackend();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(flex: 5, child: SearchResultsWidget(videos: _videos)),
          ]),
    );
  }
}
