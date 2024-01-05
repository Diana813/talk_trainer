import 'dart:convert';
import 'package:talk_trainer/models/search_response_model.dart';
import 'package:talk_trainer/utils/keys.dart';
import 'package:http/http.dart' as http;

class YouTubeApiService{

  YouTubeApiService._instantiate();
  static final YouTubeApiService youTubeApiServiceInstance = YouTubeApiService._instantiate();


  Future<List<SearchResult>> fetchVideos({required String keywords}) async {
    const String baseUrl = 'www.googleapis.com';
    const String endpoint = '/youtube/v3/search';
    String nextPageToken = '';

    Map<String, String> parameters = {
      'q': keywords,
      'key': YOUTUBE_API_KEY,
      'pageToken': nextPageToken,
      'maxResults': '25',
      'type': 'video',
      'part': 'snippet'
    };

    Uri uri = Uri.https(baseUrl, endpoint, parameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('items')) {
          List<dynamic> items = data['items'];

          List<SearchResult> videos = [];
          for (var item in items) {
            videos.add(SearchResult.fromJson(item));
          }

          nextPageToken = data['nextPageToken'];

          return videos;
        } else {
          throw 'Brak pola "items" w odpowiedzi z YouTube API.';
        }
      } else {
        throw 'Błąd zapytania: ${response.statusCode}';
      }
    } catch (error) {
      print('Wystąpił błąd: $error');
      throw 'Wystąpił błąd podczas pobierania danych z YouTube API.';
    }
  }

}