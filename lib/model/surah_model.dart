import 'package:bangla_quran/model/verse_model.dart';

class Surah {
  final int id;
  final String name;
  final String transliteration;
  final String translation;
  final List<Verse> verses;

  Surah({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.translation,
    required this.verses,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var versesList = (json['verses'] as List)
        .map((v) => Verse.fromJson(v))
        .toList();

    return Surah(
      id: json['id'],
      name: json['name'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      verses: versesList,
    );
  }
}
