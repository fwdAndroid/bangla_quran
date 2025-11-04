class Verse {
  final int verseNumber;
  final String textAr;
  final String textBn;

  Verse({
    required this.verseNumber,
    required this.textAr,
    required this.textBn,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verse_number'] ?? 0,
      textAr: json['text'] ?? '',
      textBn: json['translation'] ?? '',
    );
  }
}
