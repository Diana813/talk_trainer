import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class StartButtonFragment extends StatelessWidget {
  final bool isPlayClicked;
  final VoidCallback onPressed;

  const StartButtonFragment(
      {super.key, required this.isPlayClicked, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            isPlayClicked ? '' : 'Rozpocznij trening',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 20)),
            shadowColor:
                MaterialStateProperty.all<Color>(AppColors.primaryShadow),
            elevation: isPlayClicked ? null : MaterialStateProperty.all(1.0),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.primaryShadow[200]!;
              }
              return AppColors.lightBackground[700]!;
            }),
          ),
          onPressed: isPlayClicked ? null : onPressed,
          icon: Icon(Icons.play_arrow,
              size: 100,
              color: isPlayClicked ? AppColors.primaryShadow[100] : Colors.red),
        ),
      ],
    );
  }
}
