import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:http/http.dart' as http;

import '../models/timestamps_model.dart';

class BackendApiService {
  BackendApiService._instantiate();

  static final BackendApiService backendApiServiceInstance =
      BackendApiService._instantiate();

  Future<bool> sendAudioStreamAndReceivePauseOrder() async {
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }

  Future<UserSuccessRate> getSuccessRate() async {
    await Future.delayed(const Duration(seconds: 3));
    return UserSuccessRate(
      wordsAccuracy: 0.78,
      accentAccuracy: 0.59,
      intonationAccuracy: 0.9,
      pronunciationAccuracy: 0.8,
    );
  }

  Future<bool> uploadAudio(Uint8List bytes) async {
    const url = 'http://127.0.0.1:5000/api/upload_audio';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/octet-stream'},
      body: bytes,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Timestamp>> fetchTimestamps(String youtubeUrl) async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://127.0.0.1:5000/api/pauses_timestamps')
          .replace(queryParameters: {'youtube_url': youtubeUrl});
    } else {
      url = Uri.parse('http://10.0.2.2:5000/api/pauses_timestamps')
          .replace(queryParameters: {'youtube_url': youtubeUrl});
    }

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Timestamp> timestamps =
          jsonList.map((json) => Timestamp.fromJson(json)).toList();

      return timestamps;
    } else {
      throw Exception('Failed to load timestamps: ${response.statusCode}');
    }
  }

  Future<String> fetchVideoUrl(String youtubeUrl) async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://127.0.0.1:5000/api/video')
          .replace(queryParameters: {'youtube_url': youtubeUrl});
    } else {
      url = Uri.parse('http://10.0.2.2:5000/api/video')
          .replace(queryParameters: {'youtube_url': youtubeUrl});
    }

    try {
      var response = await http.get(url, headers: {'Accept': 'video/mp4'});

      if (response.statusCode == 200) {
        return url.path;
      } else {
        throw Exception('Failed to load video url');
      }
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> fetchUserAudioUrl() async {
    Uri url;
    if (kIsWeb) {
      url = Uri.parse('http://127.0.0.1:5000/api/get_user_audio');
    } else {
      url = Uri.parse('http://10.0.2.2:5000/api/get_user_audio');
    }

    try {
      var response = await http.get(url, headers: {'Accept': 'audio/wav'});

      if (response.statusCode == 200) {
        return 'http://127.0.0.1:5000/api/get_user_audio';
      } else {
        throw Exception('Failed to load video url');
      }
    } catch (e) {
      throw Exception('Failed to load video url $e');
    }
  }
}
