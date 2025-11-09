import 'dart:convert';
import 'package:bangla_quran/provider/font_provider.dart';
import 'package:bangla_quran/screens/details/surah_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SurahDetailEnglishScreen extends StatefulWidget {
  final int surahId;
  final int totalSurahs;

  const SurahDetailEnglishScreen({
    super.key,
    required this.surahId,
    required this.totalSurahs,
  });

  @override
  State<SurahDetailEnglishScreen> createState() =>
      _SurahDetailEnglishScreenState();
}

class _SurahDetailEnglishScreenState extends State<SurahDetailEnglishScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? currentSurah;
  bool isLoading = true;
  bool isError = false;

  late AnimationController _controller;
  Set<int> bookmarkedAyahs = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    fetchSurah(widget.surahId);
  }

  Future<void> fetchSurah(int surahId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran_en.json',
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> allSurahs = json.decode(response.body);
        setState(() {
          currentSurah = allSurahs[surahId - 1];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Surah');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  void _toggleBookmark(int index) {
    setState(() {
      if (bookmarkedAyahs.contains(index)) {
        bookmarkedAyahs.remove(index);
      } else {
        bookmarkedAyahs.add(index);
      }
    });
  }

  void _copyAyah(String arabic, String translation) {
    Clipboard.setData(ClipboardData(text: "$arabic\n$translation"));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  void _shareAyah(String arabic, String translation) {
    Share.share("$arabic\n\n$translation");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToSurah(int newSurahId) {
    if (newSurahId < 1 || newSurahId > widget.totalSurahs) return;
    setState(() {
      isLoading = true;
      currentSurah = null;
      bookmarkedAyahs.clear();
    });
    fetchSurah(newSurahId);
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text(
          currentSurah != null
              ? currentSurah!['transliteration']
              : 'Loading...',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(child: Text("Failed to load Surah"))
          : GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! < 0) {
                  _navigateToSurah(widget.surahId + 1); // next
                } else if (details.primaryVelocity! > 0) {
                  _navigateToSurah(widget.surahId - 1); // previous
                }
              },
              child: Column(
                children: [
                  SurahHeaderOrnament(
                    revelationType: "Meccan/Medinan",
                    surahName: currentSurah!['translation'],
                    totalVerses: currentSurah!['verses'].length,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: currentSurah!['verses'].length,
                      itemBuilder: (context, index) {
                        final verse = currentSurah!['verses'][index];
                        final ayahNumber = index + 1;
                        final isBookmarked = bookmarkedAyahs.contains(index);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: const Text(
                                    "Options",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: isBookmarked
                                              ? Colors.orange
                                              : Colors.grey[700],
                                        ),
                                        title: Text(
                                          isBookmarked
                                              ? "Remove Bookmark"
                                              : "Bookmark Ayah",
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _toggleBookmark(index);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.copy,
                                          color: Colors.blueGrey,
                                        ),
                                        title: const Text("Copy Ayah"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _copyAyah(
                                            verse['text'],
                                            verse['translation'],
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.share,
                                          color: Colors.green,
                                        ),
                                        title: const Text("Share Ayah"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _shareAyah(
                                            verse['text'],
                                            verse['translation'],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (fontProvider.showArabic)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green.shade50,
                                          border: Border.all(
                                            color: Colors.green.shade700,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$ayahNumber",
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: 'Amiri',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ArabicText(
                                          verse['text'],
                                          style: const TextStyle(
                                            fontFamily: 'Amiri',
                                            fontSize: 26,
                                            height: 1.8,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 8),
                                if (fontProvider.showBangla)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      verse['translation'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                if (index != currentSurah!['verses'].length - 1)
                                  AnimatedGradientDivider(
                                    controller: _controller,
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
            ),
    );
  }
}

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
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
