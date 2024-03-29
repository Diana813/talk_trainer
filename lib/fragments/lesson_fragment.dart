import 'package:flutter/material.dart';
import 'package:talk_trainer/fragments/start_fragment.dart';
import 'package:talk_trainer/fragments/user_recording_fragment.dart';
import 'package:talk_trainer/fragments/user_success_rate_fragment.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/widgets/text_popup.dart';
import 'package:talk_trainer/widgets/youtube_player.dart';
import 'package:video_player/video_player.dart';

class LessonFragment extends StatelessWidget {
  final VideoPlayerController controller;
  final bool jumpingDotsVisible;
  final bool userSuccessRateVisualizationVisible;
  final bool isPlayClicked;
  final VoidCallback onStartPressed;
  final VoidCallback onUserRecordingSubmitPressed;
  final VoidCallback? onListenPressed;
  final VoidCallback onTranslatePressed;
  final UserSuccessRate userSuccessRate;
  final bool isUploaded;

  const LessonFragment(
      {super.key,
      required this.controller,
      required this.jumpingDotsVisible,
      required this.userSuccessRateVisualizationVisible,
      required this.isPlayClicked,
      required this.onStartPressed,
      required this.onUserRecordingSubmitPressed,
      required this.onTranslatePressed,
      required this.userSuccessRate,
      required this.isUploaded,
      this.onListenPressed});

  Widget _returnRelevantWidget(BuildContext context) {
    if (jumpingDotsVisible) {
      return UserRecordingFragment(
        onPressed: onUserRecordingSubmitPressed,
      );
    } else if (userSuccessRateVisualizationVisible) {
      return UserFeedbackFragment(
        userSuccessRate: userSuccessRate,
        onPressedListen: onListenPressed,
        isUploaded: isUploaded,
        onPressedTranslate: onTranslatePressed,
      );
    } else {
      return StartButtonFragment(
        isPlayClicked: isPlayClicked,
        onPressed: onStartPressed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 2,
          child: AppYouTubePlayer(controller: controller),
        ),
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: _returnRelevantWidget(context),
          ),
        ),
      ],
    );
  }
}
