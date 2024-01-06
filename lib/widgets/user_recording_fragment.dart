import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

import '../utils/app_colors.dart';
import 'app_button.dart';

class UserRecordingFragment extends StatelessWidget {
  final VoidCallback onPressed;

  const UserRecordingFragment({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Powtórz',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: JumpingDots(
              color: AppColors.primaryBackground.shade700, radius: 15),
        ),
        AppButton(
          onPressed: onPressed,
          child: Text(
            'Zatwierdź',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
