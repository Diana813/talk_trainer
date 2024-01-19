import 'package:flutter/material.dart';
import 'package:talk_trainer/utils/app_colors.dart';

void showTextPopup(BuildContext context, title, text1, text2) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.primaryBackground[300],
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Zamknij popup
            },
            child: Text(
              'Zamknij',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
    },
  );
}
