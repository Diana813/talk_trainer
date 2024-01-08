import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class PodcastCard extends StatelessWidget {
  final String thumbnail;
  final String title;
  final String description;

  const PodcastCard(
      {super.key,
      required this.thumbnail,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.primaryShadow,
        elevation: 2,
        child: Image.network(thumbnail),
      ),
    );
  }
}
