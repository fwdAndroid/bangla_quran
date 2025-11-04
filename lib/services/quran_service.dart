import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranApiService {
  static const baseUrl =
      'https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions/bn';

  // Get all surah metadata
  static List<Map<String, dynamic>> getSurahList() {
    return List.generate(114, (index) {
      int id = index + 1;
      return {'id': id, 'name': 'সূরা $id'};
    });
  }

  // Get verses of a specific surah in Bangla
  static Future<List<dynamic>> fetchSurahVerses(int surahId) async {
    final url = Uri.parse('$baseUrl/$surahId.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['chapter'] ?? data['verses'] ?? [];
    } else {
      throw Exception('Failed to load Surah $surahId');
    }
  }
}
