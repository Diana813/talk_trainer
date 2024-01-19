import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talk_trainer/utils/keys.dart';

class GoogleTranslator {
  Future<String> translate(String text) async {
    final url =
        Uri.parse('https://translation.googleapis.com/language/translate/v2');
    final response = await http.post(url, body: {
      'q': text,
      'target': 'pl',
      'format': 'text',
      'key': '$GOOGLE_API_KEY'
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Failed to translate text');
    }
  }
}
