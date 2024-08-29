class OddEntry {
  final double odd;
  final DateTime time;

  OddEntry(this.odd, this.time);

  Map<String, dynamic> toMap() {
    return {
      'odd': odd,
      'time': time.toIso8601String(),
    };
  }
}
