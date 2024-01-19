import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/icon_button.dart';
import '../widgets/text_popup.dart';

class WebBottomNavigationFragment extends StatelessWidget {
  final VoidCallback onListenPressed;
  final VoidCallback onStartPressed;
  final VoidCallback onReplyPressed;
  final VoidCallback onTranslationPressed;

  const WebBottomNavigationFragment(
      {super.key,
      required this.onListenPressed,
      required this.onStartPressed,
      required this.onReplyPressed,
      required this.onTranslationPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppIconButton(
              backgroundColorDefault: AppColors.lightBackground[700]!,
              backgroundColorPressed: AppColors.primaryShadow[200]!,
              onPressed: onTranslationPressed,
              child: const Icon(
                Icons.translate_rounded,
                color: Colors.red,
              ),
            ),
            AppIconButton(
              backgroundColorDefault: AppColors.lightBackground[700]!,
              backgroundColorPressed: AppColors.primaryShadow[200]!,
              onPressed: onListenPressed,
              child: const Icon(Icons.headset_rounded, color: Colors.red),
            ),
            AppIconButton(
              backgroundColorDefault: AppColors.lightBackground[700]!,
              backgroundColorPressed: AppColors.primaryShadow[200]!,
              onPressed: onStartPressed,
              child: const Icon(Icons.play_arrow, color: Colors.red),
            ),
            AppIconButton(
              backgroundColorDefault: AppColors.lightBackground[700]!,
              backgroundColorPressed: AppColors.primaryShadow[200]!,
              onPressed: onReplyPressed,
              child: const Icon(Icons.replay, color: Colors.red),
            ),
          ]),
    );
  }
}
