import 'package:flutter/material.dart';
import 'package:talk_trainer/widgets/search_field.dart';

import '../models/search_response_model.dart';
import '../service/youtube_api_service.dart';

class WebSearchScreen extends StatefulWidget {
  WebSearchScreen({Key? key}) : super(key: key);

  @override
  _WebSearchScreenState createState() => _WebSearchScreenState();
}

class _WebSearchScreenState extends State<WebSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<SearchResult>> _videos = Future.value([]);
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchField(
          searchController: _searchController,
          onSubmitted: () {
            setState(() {
              _videos = YouTubeApiService.youTubeApiServiceInstance
                  .fetchVideos(keywords: _searchController.text);
            });
          },
          focusNode: _focusNode,
        ),
      ],
    );
  }
}
