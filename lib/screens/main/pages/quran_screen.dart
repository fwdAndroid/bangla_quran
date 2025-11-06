import 'dart:convert';
import 'package:bangla_quran/model/surah_model.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/screens/details/surah_detail_screen.dart';
import 'package:bangla_quran/screens/main/pages/quiz_screen.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:bangla_quran/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  List<Surah> allSurahs = [];
  List<Surah> filteredSurahs = [];
  bool isLoading = true;
  bool isError = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fetchSurahs();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      drawer: const DrawerWidget(),
      //   backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        title: ArabicText(
          languageProvider.localizedStrings["Al Quran (in Surah order)"] ??
              'Al Quran (in Surah order)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: 12),
          //   child: Icon(Icons.search, color: Colors.black),
          // ),
          // 📋 Popup Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'quiz') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'quiz',
                child: Row(
                  children: [
                    Icon(Icons.quiz_outlined, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Quiz'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Green Basmallah header
          Container(
            width: double.infinity,
            color: Colors.green[700],
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: const Center(
              child: ArabicText(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.yellow,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Surah List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isError
                ? const Center(child: ArabicText('ডাটা লোড করতে ব্যর্থ হয়েছে'))
                : ListView.separated(
                    itemCount: filteredSurahs.length,
                    separatorBuilder: (context, index) =>
                        AnimatedGradientDivider(controller: _controller),
                    itemBuilder: (context, index) {
                      var surah = filteredSurahs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) =>
                                  SurahDetailScreen(surah: surah),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Surah number circle
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.brown.shade400,
                                    width: 2.5,
                                  ),
                                ),
                                child: Center(
                                  child: ArabicText(
                                    '${surah.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Surah title and translation
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ArabicText(
                                      surah.transliteration,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    ArabicText(
                                      surah.translation,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Arabic name
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ArabicText(
                                  surah.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Amiri',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // Trailing icon
                              Icon(
                                index == 2
                                    ? Icons.access_time
                                    : Icons.cloud_download_outlined,
                                color: Colors.grey[600],
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 🌟 Animated Gradient Divider (Shimmer Center Effect)
class AnimatedGradientDivider extends StatelessWidget {
  final AnimationController controller;

  const AnimatedGradientDivider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final shimmerValue = (controller.value - 0.5).abs() * 2;
        final brightCenter = Color.lerp(
          Colors.yellow.shade600,
          Colors.yellow.shade300,
          shimmerValue,
        )!;
        return Container(
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow.shade200,
                brightCenter,
                brightCenter,
                Colors.yellow.shade200,
              ],
              stops: const [0.0, 0.4, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }
}
