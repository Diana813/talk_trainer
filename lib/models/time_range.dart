class TimeRange {
  final double start;
  final double end;

  TimeRange({required this.start, required this.end});

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}
