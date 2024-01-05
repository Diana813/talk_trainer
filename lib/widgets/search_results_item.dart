import 'package:flutter/material.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import '../models/search_response_model.dart';
import '../screens/android_lesson_screen.dart';

class SearchResultItemWidget extends StatelessWidget {
  final SearchResult result;

  const SearchResultItemWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        tileColor: AppColors.lightBackground,
        title: Text(result.snippet.title, style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(result.snippet.description, style: Theme.of(context).textTheme.bodySmall),
        leading: Image.network(result.snippet.thumbnails['default']?.url ?? 'fallback_url'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AndroidLessonScreen(result: result.id.videoId),
            ),
          );
        },
      ),
    );
  }
}