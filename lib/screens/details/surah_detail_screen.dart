import 'package:bangla_quran/provider/font_provider.dart';
import 'package:bangla_quran/screens/details/surah_header.dart';
import 'package:bangla_quran/utils/surrah_name_bangla.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangla_quran/model/surah_model.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  final List<Surah> allSurahs;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    required this.allSurahs,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Surah currentSurah;

  bool hideArabic = false;
  bool hideBangla = false;
  Set<int> bookmarkedAyahs = {};

  @override
  void initState() {
    super.initState();
    currentSurah = widget.surah;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadBookmarks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('bookmarks_${currentSurah.id}') ?? [];
    setState(() {
      bookmarkedAyahs = savedList.map(int.parse).toSet();
    });
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'bookmarks_${currentSurah.id}',
      bookmarkedAyahs.map((e) => e.toString()).toList(),
    );
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

  void _reportAyah(int ayahNumber) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Reported Ayah $ayahNumber")));
  }

  void _toggleBookmark(int index, int ayahNumber) async {
    setState(() {
      if (bookmarkedAyahs.contains(index)) {
        bookmarkedAyahs.remove(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Removed Ayah $ayahNumber from bookmarks")),
        );
      } else {
        bookmarkedAyahs.add(index);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Bookmarked Ayah $ayahNumber")));
      }
    });
    await _saveBookmarks();
  }

  void _navigateToSurah(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.allSurahs.length) return;
    setState(() {
      currentSurah = widget.allSurahs[newIndex];
      hideArabic = false;
      hideBangla = false;
    });
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSettingsProvider>(context);
    final totalAyahs = currentSurah.verses.length;
    final surahIndex = currentSurah.id - 1;

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: ArabicText(
          surahNamesBangla[currentSurah.id - 1],
          // currentSurah.translation,
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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;

          if (details.primaryVelocity! > 0) {
            _navigateToSurah(surahIndex + 1); // 👉 Swipe Right → Next
          } else if (details.primaryVelocity! < 0) {
            _navigateToSurah(surahIndex - 1); // 👈 Swipe Left → Previous
          }
        },
        child: Column(
          children: [
            SurahHeaderOrnament(
              revelationType:
                  currentSurah.type[0].toUpperCase() +
                  currentSurah.type.substring(1), // dynamic
              surahName: currentSurah.translation,
              totalVerses: totalAyahs,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   child: Container(
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       color: Colors.yellow[100],
            //       borderRadius: BorderRadius.circular(15),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.1),
            //           blurRadius: 6,
            //           offset: const Offset(0, 3),
            //         ),
            //       ],
            //       border: Border.all(color: Colors.yellow.shade700, width: 1),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //         vertical: 12,
            //         horizontal: 10,
            //       ),
            //       child: Column(
            //         children: [
            //           ArabicText(
            //             surahNamesBangla[currentSurah.id - 1],
            //             style: const TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20,
            //             ),
            //           ),
            //           const SizedBox(height: 4),
            //           Text(
            //             'Total Ayahs: $totalAyahs',
            //             style: const TextStyle(
            //               fontSize: 14,
            //               color: Colors.black87,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // 📜 Ayah List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: currentSurah.verses.length,
                itemBuilder: (context, index) {
                  final verse = currentSurah.verses[index];
                  final ayahNumber = index + 1;
                  final isBookmarked = bookmarkedAyahs.contains(index);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
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
                                          ? "বুকমার্ক সরান"
                                          : "আয়াতটি বুকমার্কে যুক্ত করুন",
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _toggleBookmark(index, ayahNumber);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.copy,
                                      color: Colors.blueGrey,
                                    ),
                                    title: const Text("আয়াতটি কপি করুন"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _copyAyah(verse.text, verse.translation);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.share,
                                      color: Colors.green,
                                    ),
                                    title: const Text("আয়াতটি শেয়ার করুন"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _shareAyah(verse.text, verse.translation);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.flag,
                                      color: Colors.red,
                                    ),
                                    title: const Text("সমস্যা রিপোর্ট করুন"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _reportAyah(ayahNumber);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.close),
                                    title: const Text("Cancel"),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (fontProvider.showArabic)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    verse.text,
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
                              child: ArabicText(
                                verse.translation,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                              ),
                            ),

                          if (index != currentSurah.verses.length - 1)
                            AnimatedGradientDivider(controller: _controller),
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
