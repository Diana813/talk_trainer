import 'package:flutter/material.dart';
import 'package:talk_trainer/models/search_response_model.dart';

import '../../service/youtube_api_service.dart';
import '../../utils/youtube_search_dummy_data.dart';
import '../../widgets/search_results_widget.dart';

class AndroidSearchResultsScreen extends StatefulWidget {
  final String keywords;

  const AndroidSearchResultsScreen({super.key, required this.keywords});

  @override
  _AndroidSearchResultsScreenState createState() =>
      _AndroidSearchResultsScreenState();
}

class _AndroidSearchResultsScreenState
    extends State<AndroidSearchResultsScreen> {
  late Future<List<SearchResult>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = YouTubeApiService.youTubeApiServiceInstance
        .fetchDummyData(dummySearchResultsLearningScreenData);

        //YouTubeApiService.youTubeApiServiceInstance.fetchVideos(keywords: widget.keywords);
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
      body: SearchResultsWidget(videos: _videos),
    );
  }
}
