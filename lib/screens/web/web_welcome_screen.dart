import 'package:flutter/material.dart';
import 'package:talk_trainer/screens/web/web_learning_screen.dart';
import 'package:talk_trainer/utils/youtube_search_dummy_data.dart';
import 'package:talk_trainer/widgets/podcast_card.dart';
import 'package:talk_trainer/widgets/welcome_text.dart';

import '../../models/search_response_model.dart';
import '../../service/youtube_api_service.dart';
import '../../widgets/search_field.dart';

class WebWelcomeScreen extends StatefulWidget {
  const WebWelcomeScreen({super.key});

  @override
  _WebWelcomeScreenState createState() => _WebWelcomeScreenState();
}

class _WebWelcomeScreenState extends State<WebWelcomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<SearchResult>> _podcasts;

  @override
  void initState() {
    super.initState();
    _podcasts = YouTubeApiService.youTubeApiServiceInstance
        .fetchDummyData(dummySearchResults);
    //TODO zamienić na prawdziwą metodę
    //YouTubeApiService.youTubeApiServiceInstance.fetchLatestPodcasts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: WelcomeText(),
              ),
              SearchField(
                searchController: _searchController,
                onSubmitted: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebLearningScreen(
                            keywords: _searchController.text)),
                  );
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: _podcasts,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SearchResult>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child:
                            Text('Błąd pobierania danych: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Brak dostępnych podcastów.'),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebLearningScreen(
                                    keywords:
                                        snapshot.data![index].snippet.title,
                                  ),
                                ),
                              );
                            },
                            child: PodcastCard(
                              thumbnail: snapshot.data![index].snippet
                                  .thumbnails.highThumbnail.url,
                              title: snapshot.data![index].snippet.title,
                              description:
                                  snapshot.data![index].snippet.description,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}
