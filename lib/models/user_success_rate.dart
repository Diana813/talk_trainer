class UserSuccessRate {
  double wordsAccuracy;
  double accentAccuracy;
  double intonationAccuracy;
  double pronunciationAccuracy;

  UserSuccessRate({
    required this.wordsAccuracy,
    required this.accentAccuracy,
    required this.intonationAccuracy,
    required this.pronunciationAccuracy,
  });

  factory UserSuccessRate.fromJson(Map<String, dynamic> json) {
    return UserSuccessRate(
      wordsAccuracy: json['wordsAccuracy'] ?? 0,
      accentAccuracy: json['accentAccuracy'] ?? 0,
      intonationAccuracy: json['intonationAccuracy'] ?? 0,
      pronunciationAccuracy: json['pronunciationAccuracy'] ?? 0,
    );
  }
}
