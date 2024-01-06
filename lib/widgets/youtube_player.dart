import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AppYouTubePlayer extends StatelessWidget {
  final YoutubePlayerController youtubePlayerController;

  const AppYouTubePlayer({super.key, required this.youtubePlayerController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      child: YoutubePlayer(
        controller: youtubePlayerController,
        aspectRatio: 16 / 9,
      ),
    );
  }
}
