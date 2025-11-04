import 'dart:convert';
import 'package:bangla_quran/model/surah_model.dart';
import 'package:bangla_quran/screens/details/surah_detail_screen.dart';
import 'package:bangla_quran/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<Surah> allSurahs = [];
  List<Surah> filteredSurahs = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchSurahs();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  /// Fetches Surahs from the online JSON
  Future<void> fetchSurahs() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran_bn.json',
        ),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        allSurahs = jsonResponse.map((s) => Surah.fromJson(s)).toList();
        setState(() {
          filteredSurahs = allSurahs;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Surahs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  /// Handles text search input changes
  void _onSearchChanged() {
    String query = searchController.text.toLowerCase().trim();
    setState(() {
      filteredSurahs = allSurahs.where((surah) {
        final name = surah.name.toLowerCase();
        final transliteration = surah.transliteration.toLowerCase();
        final translation = surah.translation.toLowerCase();
        final number = surah.toString();
        return name.contains(query) ||
            transliteration.contains(query) ||
            translation.contains(query) ||
            number.startsWith(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search Surah by name, translation, or number...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(child: Text('Failed to load Surahs'))
          : filteredSurahs.isEmpty
          ? const Center(child: Text('No Surah found'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                var surah = filteredSurahs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[700],
                      child: Text(
                        '${surah.id}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      surah.transliteration,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${surah.translation} • ${surah.name}'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahDetailScreen(surah: surah),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
