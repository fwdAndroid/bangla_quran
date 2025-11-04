import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranApiService {
  static const baseUrl =
      'https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions';

  // Fetch list of Surahs (you already have JSON from your example)
  static Future<Map<String, dynamic>> fetchSurahList() async {
    final response = await http.get(Uri.parse('$baseUrl/bn.json'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  // Fetch verses for a specific surah in Bangla translation
  static Future<List<dynamic>> fetchSurahVerses(int surahId) async {
    final response = await http.get(Uri.parse('$baseUrl/bn/$surahId.json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['chapter'] ?? data['verses'] ?? [];
    } else {
      throw Exception('Failed to load verses');
    }
  }
}
