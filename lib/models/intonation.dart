class Intonation {
  List<double> lectorIntonation;
  List<double> userIntonation;

  Intonation({
    required this.lectorIntonation,
    required this.userIntonation,
  });

  factory Intonation.fromJson(Map<String, dynamic> json) {
    return Intonation(
      lectorIntonation:
          (json['lectorIntonation'] as List).map((e) => e as double).toList(),
      userIntonation:
          (json['userIntonation'] as List).map((e) => e as double).toList(),
    );
  }
}
