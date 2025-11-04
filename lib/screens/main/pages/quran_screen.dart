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
  late Future<List<Surah>> surahs;
  List<Surah> allSurahs = [];
  List<Surah> filteredSurahs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    surahs = fetchSurahs();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<List<Surah>> fetchSurahs() async {
    final response = await http.get(
      Uri.parse(
        'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran_bn.json',
      ),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      allSurahs = jsonResponse.map((s) => Surah.fromJson(s)).toList();
      filteredSurahs = allSurahs;
      return allSurahs;
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSurahs = allSurahs.where((surah) {
        final nameLower = surah.name.toLowerCase();
        return nameLower.contains(query) || nameLower.startsWith(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search Surah by name or first letter...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Surah>>(
              future: surahs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (filteredSurahs.isEmpty) {
                    return const Center(child: Text('No Surah found.'));
                  }
                  return ListView.builder(
                    itemCount: filteredSurahs.length,
                    itemBuilder: (context, index) {
                      var surah = filteredSurahs[index];
                      return Card(
                        child: ListTile(
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                          title: Text('${surah.transliteration}'),
                          subtitle: Text('${surah.translation} ${surah.name}'),
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
