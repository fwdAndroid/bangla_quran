import 'dart:convert';

import 'package:bangla_quran/model/surah_model.dart';
import 'package:bangla_quran/screens/details/surah_detail_screen.dart';
import 'package:bangla_quran/services/quran_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<List<Surah>> surahs;
  @override
  void initState() {
    super.initState();
    surahs = fetchSurahs();
  }

  Future<List<Surah>> fetchSurahs() async {
    final response = await http.get(
      Uri.parse(
        'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran_bn.json',
      ),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((s) => Surah.fromJson(s)).toList();
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 আল-কুরআন (Bangla Translation)"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<List<Surah>>(
        future: surahs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var surah = snapshot.data![index];
                return ListTile(
                  title: Text('${surah.id}. ${surah.name}'),
                  subtitle: Text(surah.translation),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailScreen(surah: surah),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
