class Timestamp {
  final double millis;

  Timestamp({required this.millis});

  factory Timestamp.fromJson(dynamic json) {
    return Timestamp(millis: json as double);
  }
}
