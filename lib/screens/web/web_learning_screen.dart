import 'package:flutter/material.dart';
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

    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.close();
    _audioHelper.dispose();
    super.dispose();
  }

  Future<void> recordAndStreamAudioToBackend() async {
    setState(() {
      _isRecording = true;
    });
    _audioHelper.record();
    _youtubePlayerController.playVideo();

    //todo stream to backend
    bool pauseOrder = await BackendApiService.backendApiServiceInstance
        .sendAudioStreamAndReceivePauseOrder();

    if (pauseOrder) {
      _youtubePlayerController.pauseVideo();
      _audioHelper.stopRecording();
      setState(() {
        _isRecording = false;
      });

      recordUserAudio();
    }
  }

  Future<void> recordReplayAndStreamAudioToBackend() async {
    setState(() {
      _isRecording = true;
    });
    _audioHelper.record();

    setState(() {
      _isPlaying = true;
    });
    _audioHelper.play();

    if (_isPlaying == false) {
      recordUserAudio();
    }
  }

  Future<void> recordUserAudio() async {
    setState(() {
      _isRecording = true;
    });
    _audioHelper.record();

    //todo send to backend
    _userSuccessRate = await BackendApiService.backendApiServiceInstance
        .sendUserAudioStreamAndReceiveSuccessRate();
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
                jumpingDotsVisible: _isRecording,
                userSuccessRateVisualizationVisible:
                    _isPlayClicked && !_isRecording && !_isPlaying,
                isPlayClicked: _isPlayClicked,
                onStartPressed: () {
                  if (!_isRecording && !_isPlaying) {
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
            ),
            Expanded(flex: 5, child: SearchResultsWidget(videos: _videos)),
          ]),
    );
  }
}
