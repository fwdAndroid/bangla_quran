import 'dart:convert';
import 'package:bangla_quran/screens/details/english_surah_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bangla_quran/screens/details/surah_detail_screen.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';

class QuranEnglishScreen extends StatefulWidget {
  const QuranEnglishScreen({super.key});

  @override
  State<QuranEnglishScreen> createState() => _QuranEnglishScreenState();
}

class _QuranEnglishScreenState extends State<QuranEnglishScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> allSurahs = [];
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
          'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran_en.json',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          allSurahs = json.decode(response.body);
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(child: Text('Failed to load Quran in English'))
          : ListView.separated(
              itemCount: allSurahs.length,
              separatorBuilder: (context, index) =>
                  AnimatedGradientDivider(controller: _controller),
              itemBuilder: (context, index) {
                final surah = allSurahs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => SurahDetailEnglishScreen(
                          surahId: surah['id'],
                          totalSurahs: allSurahs.length, // ✅ correct
                        ),
                      ),
                    );
                    // Optional: Navigate to Surah detail screen in English
                    // You can reuse SurahDetailScreen if you adapt it for English
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 18, right: 18),
                    color: cardColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🔵 Surah number
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
                            child: Text(
                              '${surah['id']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Surah title & translation
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah['transliteration'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                surah['translation'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arabic name
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ArabicText(
                            surah['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),

                        // Trailing icon
                        Icon(
                          index == 2
                              ? Icons.access_time
                              : Icons.cloud_download_outlined,
                          color: subtitleColor,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                );
              },
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
