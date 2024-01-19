import 'package:talk_trainer/models/transcription.dart';

import 'intonation.dart';

class UserSuccessRate {
  double wordsAccuracy;
  Transcription transcription;
  double accentAccuracy;
  double intonationAccuracy;
  Intonation intonation;
  double pronunciationAccuracy;

  UserSuccessRate({
    required this.wordsAccuracy,
    required this.transcription,
    required this.accentAccuracy,
    required this.intonationAccuracy,
    required this.intonation,
    required this.pronunciationAccuracy,
  });

  factory UserSuccessRate.fromJson(Map<String, dynamic> json) {
    return UserSuccessRate(
      wordsAccuracy: json['wordsAccuracy'] ?? 0,
      transcription:
          Transcription.fromJson(json['transcription'] as Map<String, dynamic>),
      accentAccuracy: json['accentAccuracy'] ?? 0,
      intonationAccuracy: json['intonationAccuracy'] ?? 0,
      intonation:
          Intonation.fromJson(json['intonation'] as Map<String, dynamic>),
      pronunciationAccuracy: json['pronunciationAccuracy'] ?? 0,
    );
  }
}
