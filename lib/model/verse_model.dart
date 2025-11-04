// Model classes
class Verse {
  final int id;
  final String text;
  final String translation;

  Verse({required this.id, required this.text, required this.translation});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      text: json['text'],
      translation: json['translation'],
    );
  }
}
