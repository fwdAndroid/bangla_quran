import 'package:bangla_quran/services/quran_service.dart';
import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahId;
  final String surahName;

  const SurahDetailScreen({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late Future<List<dynamic>> _versesFuture;

  @override
  void initState() {
    super.initState();
    _versesFuture = QuranApiService.fetchSurahVerses(widget.surahId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _versesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final verses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        verse['arabic_text'] ?? verse['text'] ?? '',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ScheherazadeNew',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          verse['translation'] ?? '',
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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
