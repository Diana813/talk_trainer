class Transcription {
  String lectorTranscription;
  String userTranscription;

  Transcription({
    required this.lectorTranscription,
    required this.userTranscription,
  });

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      lectorTranscription: json['lectorTranscription'] ?? '',
      userTranscription: json['userTranscription'] ?? '',
    );
  }
}
