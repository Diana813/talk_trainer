import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.network(thumbnail),
    );
  }
}
