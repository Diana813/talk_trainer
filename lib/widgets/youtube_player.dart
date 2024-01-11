import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AppYouTubePlayer extends StatelessWidget {
  final YoutubePlayerController youtubePlayerController;

  const AppYouTubePlayer({super.key, required this.youtubePlayerController});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: YoutubePlayer(
                controller: youtubePlayerController,
              ),
            ),
          ),
        ],
      ),
      Container(
        color: Colors.transparent,
      )
    ]);
  }
}
