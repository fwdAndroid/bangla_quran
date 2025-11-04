import 'package:bangla_quran/model/surah_model.dart';
import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("সূরা ${widget.surahId}"),
      //   backgroundColor: Colors.green[700],
      // ),
      body: ListView.builder(
        itemCount: widget.surah.verses.length,
        itemBuilder: (context, index) {
          var verse = widget.surah.verses[index];
          return ListTile(
            title: Text(verse.text, style: TextStyle(fontSize: 20)),
            subtitle: Text(verse.translation, style: TextStyle(fontSize: 16)),
          );
        },
      ),
    );
  }
}
