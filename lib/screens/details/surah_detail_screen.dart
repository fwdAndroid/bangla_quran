import 'package:bangla_quran/model/surah_model.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 🌟 Animation controller for shimmer divider
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: ArabicText(
          widget.surah.translation,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: widget.surah.verses.length,
        itemBuilder: (context, index) {
          final verse = widget.surah.verses[index];
          final ayahNumber = index + 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Arabic text with ayah number
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: verse.text,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 26,
                          height: 1.8,
                          color: Colors.black,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green,
                                width: 1.8,
                              ),
                            ),
                            child: Center(
                              child: ArabicText(
                                '$ayahNumber',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Bangla translation
                Align(
                  alignment: Alignment.centerLeft,
                  child: ArabicText(
                    verse.translation,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),

                // 🌟 Animated Divider (same shimmer style as previous screen)
                if (index != widget.surah.verses.length - 1)
                  AnimatedGradientDivider(controller: _controller),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 🌟 Animated Gradient Divider (Reused)
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
