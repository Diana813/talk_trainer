import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:talk_trainer/fragments/lesson_fragment.dart';
import 'package:talk_trainer/fragments/web_bottom_navigation.dart';
import 'package:talk_trainer/models/search_response_model.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import 'package:talk_trainer/utils/youtube_search_dummy_data.dart';
import 'package:video_player/video_player.dart';

import '../../models/intonation.dart';
import '../../models/time_range.dart';
import '../../models/timestamps_model.dart';
import '../../models/transcription.dart';
import '../../models/user_success_rate.dart';
import '../../service/backend_api_service.dart';
import '../../service/google_translate_api_service.dart';
import '../../service/youtube_api_service.dart';
import '../../utils/audio_helper.dart';
import '../../utils/youtube_helper.dart';
import '../../widgets/search_results_widget.dart';
import '../../widgets/text_popup.dart';

class WebLearningScreen extends StatefulWidget {
  final String keywords;

  const WebLearningScreen({super.key, required this.keywords});

  @override
  _WebLearningScreenState createState() => _WebLearningScreenState();
}

class _WebLearningScreenState extends State<WebLearningScreen> {
  late Future<List<SearchResult>> _videos;
  late final VideoPlayerController _videoPlayerController;
  late final YoutubePlayerHelper _youtubePlayerHelper;
  late GoogleTranslator _translator;
  late AudioHelper _audioHelper;
  late Future<List<dynamic>> _dataFuture;
  late List<Timestamp> _pausesTimestamps;
  late String _videoUrl;
  late Uint8List _audioBytes;

  bool _isPlayClicked = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isUploaded = false;

  int _startVideo = 0;
  int _stopVideo = 0;

  UserSuccessRate _userSuccessRate = UserSuccessRate(
    wordsAccuracy: 0,
    transcription: Transcription(
      lectorTranscription: '',
      userTranscription: '',
    ),
    accentAccuracy: 0,
    intonationAccuracy: 0,
    intonation: Intonation(lectorIntonation: [], userIntonation: []),
    pronunciationAccuracy: 0,
  );

  @override
  void initState() {
    _audioHelper = AudioHelper();
    _translator = GoogleTranslator();

    _dataFuture = Future.wait([
      BackendApiService.backendApiServiceInstance
          .fetchVideoUrl('https://www.youtube.com/watch?v=48jlHaxZnig'),
      BackendApiService.backendApiServiceInstance
          .fetchTimestamps('https://www.youtube.com/watch?v=48jlHaxZnig')
    ]);

    _dataFuture.then((results) {
      if (results.isNotEmpty) {
        _videoUrl =
            'http://127.0.0.1:5000/api/video?youtube_url=https://www.youtube.com/watch?v=48jlHaxZnig';
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

    _videos = YouTubeApiService.youTubeApiServiceInstance
        .fetchDummyData(dummySearchResultsLearningScreenData);
    //todo - zamienić na prawdziwą metodę
    //YouTubeApiService.youTubeApiServiceInstance.fetchVideos(keywords: widget.keywords);

    /*  _videos
        .then((value) => _youtubePlayerController.loadVideoById(
            videoId: value.first.id.videoId))
        .then((value) => _youtubePlayerController.stopVideo());*/

    super.initState();
  }

  @override
  void dispose() {
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

        Duration? currentTime = await _videoPlayerController.position;
        _stopVideo = currentTime!.inMilliseconds;

        setState(() {
          _isPlaying = false;
          _isPaused = true;
        });

        recordUserAudio();
      }
    });
  }

  Future<void> playVideoSegment() async {
    await _videoPlayerController.play();
    Duration? currentTime = await _videoPlayerController.position;
    _startVideo = currentTime!.inMilliseconds;

    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });
  }

  Future<void> replayVideoSegment() async {
    await _videoPlayerController.seekTo(Duration(milliseconds: _startVideo));

    await _videoPlayerController.play();
    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });

    await Future.delayed(Duration(milliseconds: _stopVideo - _startVideo));

    await _videoPlayerController.pause();
    setState(() {
      _isPlaying = false;
      _isPaused = true;
    });
    recordUserAudio();
  }

  Future<void> recordUserAudio() async {
    setState(() {
      _isRecording = true;
    });

    var stream = await _audioHelper.record();
    var byteList = await stream.toList();
    _audioBytes = Uint8List.fromList(byteList.expand((x) => x).toList());
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
                    child: FutureBuilder<List<dynamic>>(
                        future: _dataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dzielę film na fragmenty do powtarzania',
                                    ),
                                  ),
                                ),
                                CircularProgressIndicator(
                                  color: AppColors.secondaryMedium,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Brak danych');
                          } else {
                            return LessonFragment(
                              controller: _videoPlayerController,
                              jumpingDotsVisible: _isPaused && _isRecording,
                              userSuccessRateVisualizationVisible:
                                  !_isRecording && _isPaused,
                              isPlayClicked: _isPlayClicked,
                              onStartPressed: () {
                                if (!_isRecording &&
                                    !_isPlaying &&
                                    !_isPlayClicked) {
                                  setState(() {
                                    _isPlayClicked = true;
                                    _isUploaded = false;
                                  });
                                  playVideoSegment();
                                }
                              },
                              onUserRecordingSubmitPressed: () async {
                                await _audioHelper.stopRecording();
                                setState(() {
                                  _isRecording = false;
                                });

                                _isUploaded = await BackendApiService
                                    .backendApiServiceInstance
                                    .uploadAudio(
                                        _audioBytes,
                                        TimeRange(
                                            start: _startVideo / 1000,
                                            end: _stopVideo / 1000));

                                setState(() {});

                                if (_isUploaded) {
                                  _userSuccessRate = await BackendApiService
                                      .backendApiServiceInstance
                                      .getSuccessRate();
                                }

                                setState(() {});
                              },
                              userSuccessRate: _userSuccessRate,
                              onListenPressed: () {},
                              isUploaded: _isUploaded,
                              onTranslatePressed: () async {
                                await _translator
                                    .translate(_userSuccessRate
                                        .transcription.lectorTranscription)
                                    .then((value) {
                                  showTextPopup(
                                      context,
                                      "Tłumaczenie",
                                      _userSuccessRate
                                          .transcription.lectorTranscription,
                                      value);
                                });
                              },
                            );
                          }
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: WebBottomNavigationFragment(
                      onListenPressed: () async {
                        String userAudioUrl = await BackendApiService
                            .backendApiServiceInstance
                            .fetchUserAudioUrl();
                        userAudioUrl =
                            "$userAudioUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}";
                        _audioHelper.play(userAudioUrl);
                      },
                      onStartPressed: () {
                        if (!_isRecording && !_isPlaying) {
                          setState(() {
                            _isPlayClicked = true;
                            _isUploaded = false;
                          });
                          playVideoSegment();
                        }
                      },
                      onReplyPressed: () {
                        if (!_isRecording && !_isPlaying) {
                          replayVideoSegment();
                          _isUploaded = false;
                        }
                      },
                      onTranslationPressed: () async {
                        await _translator
                            .translate(_userSuccessRate
                                .transcription.lectorTranscription)
                            .then((value) {
                          showTextPopup(
                              context,
                              "Tłumaczenie",
                              _userSuccessRate
                                  .transcription.lectorTranscription,
                              value);
                        });
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
