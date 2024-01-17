import 'package:flutter/material.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import 'package:video_player/video_player.dart';

class AppYouTubePlayer extends StatelessWidget {
  //final YoutubePlayerController youtubePlayerController;
  final VideoPlayerController controller;

  const AppYouTubePlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    )
                  : Container(),
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
