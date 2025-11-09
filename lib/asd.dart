import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model for Ayah
class Ayah {
  final int id;
  final String text;
  final String translation;

  Ayah({required this.id, required this.text, required this.translation});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      id: json['id'],
      text: json['text'],
      translation: json['translation'],
    );
  }
}

// Model for Surah
class Surah {
  final int id;
  final String name;
  final List<Ayah> verses;

  Surah({required this.id, required this.name, required this.verses});

  factory Surah.fromJson(Map<String, dynamic> json) {
    var versesList = (json['verses'] as List)
        .map((v) => Ayah.fromJson(v))
        .toList();
    return Surah(id: json['id'], name: json['name'], verses: versesList);
  }
}

// Juz Screen
class JuzScreen extends StatefulWidget {
  const JuzScreen({super.key});

  @override
  State<JuzScreen> createState() => _JuzScreenState();
}

class _JuzScreenState extends State<JuzScreen> {
  List<List<Ayah>> juzList = []; // List of Juz, each Juz is list of Ayah
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuranData();
  }

  Future<void> fetchQuranData() async {
    final response = await http.get(
      Uri.parse(
        'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran_bn.json',
      ),
    );

    if (response.statusCode == 200) {
      List surahJson = json.decode(response.body);
      List<Surah> surahList = surahJson.map((s) => Surah.fromJson(s)).toList();

      // Combine all ayahs sequentially
      List<Ayah> allAyahs = [];
      for (var surah in surahList) {
        allAyahs.addAll(surah.verses);
      }

      // Divide into 30 Juz
      int ayahPerJuz = (allAyahs.length / 30).ceil();
      List<List<Ayah>> tempJuz = [];
      for (int i = 0; i < 30; i++) {
        int start = i * ayahPerJuz;
        int end = ((i + 1) * ayahPerJuz < allAyahs.length)
            ? (i + 1) * ayahPerJuz
            : allAyahs.length;
        tempJuz.add(allAyahs.sublist(start, end));
      }

      setState(() {
        juzList = tempJuz;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Quran data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juz')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: juzList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Juz ${index + 1}'),
                  subtitle: Text(
                    'Ayahs: ${juzList[index].length}, First Ayah: ${juzList[index][0].translation}',
                  ),
                  onTap: () {
                    // Open Juz Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JuzDetailScreen(
                          juzNumber: index + 1,
                          ayahs: juzList[index],
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

// Juz Detail Screen
class JuzDetailScreen extends StatelessWidget {
  final int juzNumber;
  final List<Ayah> ayahs;

  const JuzDetailScreen({
    super.key,
    required this.juzNumber,
    required this.ayahs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juz $juzNumber')),
      body: ListView.builder(
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final ayah = ayahs[index];
          return ListTile(
            title: Text(ayah.text, textAlign: TextAlign.right),
            subtitle: Text(ayah.translation),
          );
        },
      ),
    );
  }
}
