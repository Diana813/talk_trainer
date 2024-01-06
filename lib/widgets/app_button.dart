import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const AppButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).primaryColorDark;
            }
            return AppColors.primaryHighlight;
          }),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
            return Theme.of(context).textTheme.bodyMedium!;
          }),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
