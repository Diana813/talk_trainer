import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppIconButton extends StatelessWidget {
  final Icon child;
  final VoidCallback onPressed;

  const AppIconButton(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 20)
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            )
        ),
        shadowColor: MaterialStateProperty.all<Color>(AppColors.primaryShadow),
        elevation: MaterialStateProperty.all(1.0),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme
                    .of(context)
                    .primaryColorDark;
              }
              return AppColors.primaryHighlight[700]!;
            }),
      ),
      onPressed: onPressed,
      icon: child,
    );
  }
}
