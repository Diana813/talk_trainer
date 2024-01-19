import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:talk_trainer/models/search_response_model.dart';
import 'package:talk_trainer/utils/keys.dart';
import 'package:http/http.dart' as http;

import '../utils/youtube_search_dummy_data.dart';

class YouTubeApiService {
  YouTubeApiService._instantiate();

  static final YouTubeApiService youTubeApiServiceInstance =
      YouTubeApiService._instantiate();

  Future<List<SearchResult>> fetchVideos({required String keywords}) async {
    const String baseUrl = 'www.googleapis.com';
    const String endpoint = '/youtube/v3/search';
    String nextPageToken = '';

    Map<String, String> parameters = {
      'q': keywords,
      'key': GOOGLE_API_KEY,
      'pageToken': nextPageToken,
      'maxResults': '25',
      'type': 'video',
      'part': 'snippet'
    };

    Uri uri = Uri.https(baseUrl, endpoint, parameters);

    try {
      final response = await http.get(uri);

      print(response.body);

      if (response.statusCode == 200) {
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

  Future<List<SearchResult>> fetchLatestPodcasts() async {
    const String baseUrl = 'www.googleapis.com';
    const String endpoint = '/youtube/v3/search';
    String sevenDaysAgo = DateFormat('yyyy-MM-ddTHH:mm:ssZ')
        .format(DateTime.now().subtract(const Duration(days: 7)));

    Map<String, String> parameters = {
      'q': 'podcast',
      'key': GOOGLE_API_KEY,
      'maxResults': '8',
      'type': 'video',
      'part': 'snippet',
      'order': 'viewCount',
      'publishedAfter': '${sevenDaysAgo}Z'
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

  Future<List<SearchResult>> fetchDummyData(
      Map<String, dynamic> dummyData) async {
    List<dynamic> items = dummyData['items'];

    List<SearchResult> videos = [];
    for (var item in items) {
      videos.add(SearchResult.fromJson(item));
    }
    return videos;
  }
}
