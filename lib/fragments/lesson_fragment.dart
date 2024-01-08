import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/fragments/start_fragment.dart';
import 'package:talk_trainer/widgets/translation_pop_up.dart';
import 'package:talk_trainer/fragments/user_recording_fragment.dart';
import 'package:talk_trainer/fragments/user_success_rate_fragment.dart';
import 'package:talk_trainer/widgets/youtube_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../utils/app_colors.dart';
import '../widgets/icon_button.dart';

class LessonFragment extends StatelessWidget {
  final YoutubePlayerController youtubePlayerController;
  final bool jumpingDotsVisible;
  final bool userSuccessRateVisualizationVisible;
  final bool isPlayClicked;
  final VoidCallback onStartPressed;
  final VoidCallback onUserRecordingSubmitPressed;
  final UserSuccessRate userSuccessRate;

  const LessonFragment(
      {super.key,
      required this.youtubePlayerController,
      required this.jumpingDotsVisible,
      required this.userSuccessRateVisualizationVisible,
      required this.isPlayClicked,
      required this.onStartPressed,
      required this.onUserRecordingSubmitPressed,
      required this.userSuccessRate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: AppYouTubePlayer(
              youtubePlayerController: youtubePlayerController),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible:
                    !jumpingDotsVisible && !userSuccessRateVisualizationVisible,
                child: StartButtonFragment(
                  isPlayClicked: isPlayClicked,
                  onPressed: onStartPressed,
                ),
              ),
              Visibility(
                visible: jumpingDotsVisible,
                child: UserRecordingFragment(
                  onPressed: onUserRecordingSubmitPressed,
                ),
              ),
              Visibility(
                  visible: userSuccessRateVisualizationVisible,
                  child: UserFeedbackFragment(
                    userSuccessRate: userSuccessRate,
                    onPressedListen: () {},
                    onPressedTranslate: () {
                      showPopup(context);
                    },
                  )),
            ],
          ),
        ),
        Visibility(
            visible: kIsWeb,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppIconButton(
                      backgroundColorDefault: AppColors.lightBackground[700]!,
                      backgroundColorPressed: AppColors.primaryShadow[200]!,
                      onPressed: () {
                        showPopup(context);
                      },
                      child: const Icon(Icons.translate_rounded, color: Colors.red,),
                    ),
                    AppIconButton(
                      backgroundColorDefault: AppColors.lightBackground[700]!,
                      backgroundColorPressed: AppColors.primaryShadow[200]!,
                      onPressed: () {},
                      child: const Icon(Icons.headset_rounded, color: Colors.red),
                    ),
                    AppIconButton(
                      backgroundColorDefault: AppColors.lightBackground[700]!,
                      backgroundColorPressed: AppColors.primaryShadow[200]!,
                      onPressed: () {},
                      child: const Icon(Icons.play_arrow, color: Colors.red),
                    ),
                    AppIconButton(
                      backgroundColorDefault: AppColors.lightBackground[700]!,
                      backgroundColorPressed: AppColors.primaryShadow[200]!,
                      onPressed: () {},
                      child: const Icon(Icons.replay, color: Colors.red),
                    ),
                  ]),
            ))
      ],
    );
  }
}
