import 'package:flutter/material.dart';
import 'package:talk_trainer/widgets/search_results_item.dart';

import '../models/search_response_model.dart';
import '../utils/app_colors.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    super.key,
    required Future<List<SearchResult>> videos,
  }) : _videos = videos;

  final Future<List<SearchResult>> _videos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchResult>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.secondaryMedium,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Brak danych');
          } else {
            List<SearchResult> searchResults = snapshot.data!;
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return SearchResultItemWidget(result: searchResults[index]);
              },
            );
          }
        },
    );
  }
}