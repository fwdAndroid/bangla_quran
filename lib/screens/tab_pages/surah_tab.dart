import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Surah {
  final int number;
  final String englishName;
  final String arabicName;
  final String revelationType;
  final int numberOfVerses;

  Surah({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.revelationType,
    required this.numberOfVerses,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['id'],
      englishName: json['translation'],
      arabicName: json['name'],
      revelationType: json['type'],
      numberOfVerses: json['total_verses'],
    );
  }
}

class SurahTab extends StatefulWidget {
  const SurahTab({super.key});

  @override
  State<SurahTab> createState() => _SurahTabState();
}

class _SurahTabState extends State<SurahTab> {
  late Future<List<Surah>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _surahsFuture = fetchSurahs();
  }

  Future<List<Surah>> fetchSurahs() async {
    final response = await http.get(
      Uri.parse(
        'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/chapters/en/index.json',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Surah>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final surahs = snapshot.data!;

          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${surah.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(surah.englishName),
                subtitle: Text(
                  '${surah.revelationType} • ${surah.numberOfVerses} verses',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Text(
                  surah.arabicName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri', // Use Arabic-supported font
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
