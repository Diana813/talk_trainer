import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:http/http.dart' as http;

import '../models/intonation.dart';
import '../models/time_range.dart';
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
    Uri url = Uri.parse('http://127.0.0.1:5000/api/get_user_success_rate');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return UserSuccessRate.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load user success rate: ${response.statusCode}');
    }
  }

  Future<Intonation> getIntonationData() async {
    Uri url = Uri.parse('http://127.0.0.1:5000/api/get_intonation_data');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return Intonation.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load user success rate: ${response.statusCode}');
    }
  }

  Future<bool> uploadAudio(Uint8List bytes, TimeRange timeRange) async {
    const url = 'http://127.0.0.1:5000/api/upload_audio';
    var timeRangeJson = json.encode(timeRange.toJson());

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(http.MultipartFile.fromBytes('audio', bytes,
          filename: 'user_audio.wav'))
      ..fields['timeRange'] = timeRangeJson;

    var response = await request.send();

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
