import 'package:bangla_quran/screens/details/surah_detail_screen.dart';
import 'package:bangla_quran/services/quran_service.dart';
import 'package:flutter/material.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<Map<String, dynamic>> _surahListFuture;

  @override
  void initState() {
    super.initState();
    _surahListFuture = QuranApiService.fetchSurahList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 আল-কুরআন (Bangla Translation)"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _surahListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final surahs = snapshot.data!['surahs'] as List<dynamic>;
          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    '${surah['id']}. ${surah['transliteration']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${surah['name']} — ${surah['translation']}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Text(
                    '${surah['total_verses']} আয়াত',
                    style: const TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailScreen(
                          surahId: surah['id'],
                          surahName: surah['transliteration'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
