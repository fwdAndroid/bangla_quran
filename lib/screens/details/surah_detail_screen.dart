import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangla_quran/model/surah_model.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool hideArabic = false;
  bool hideBangla = false;
  int? expandedAyahIndex;
  Set<int> bookmarkedAyahs = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadBookmarks(); // ✅ Load saved bookmarks
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ Load bookmarked Ayahs from SharedPreferences
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('bookmarks_${widget.surah.id}') ?? [];
    setState(() {
      bookmarkedAyahs = savedList.map(int.parse).toSet();
    });
  }

  /// ✅ Save bookmarked Ayahs to SharedPreferences
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'bookmarks_${widget.surah.id}',
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

  @override
  Widget build(BuildContext context) {
    final totalAyahs = widget.surah.verses.length;

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
      body: Column(
        children: [
          // 🔘 Top toggles
          Container(
            color: Colors.yellow[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: !hideArabic,
                      onChanged: (value) {
                        setState(() => hideArabic = !(value ?? true));
                      },
                    ),
                    const Text(
                      "Show Arabic",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Checkbox(
                      value: !hideBangla,
                      onChanged: (value) {
                        setState(() => hideBangla = !(value ?? true));
                      },
                    ),
                    const Text(
                      "Show Bangla",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.yellow.shade700, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    ArabicText(
                      widget.surah.translation,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Ayahs: $totalAyahs',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 📜 Ayah List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: widget.surah.verses.length,
              itemBuilder: (context, index) {
                final verse = widget.surah.verses[index];
                final ayahNumber = index + 1;
                final isExpanded = expandedAyahIndex == index;
                final isBookmarked = bookmarkedAyahs.contains(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Arabic text
                      if (!hideArabic)
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
                              TextSpan(
                                text: ' ﴿$ayahNumber﴾ ',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 20,
                                  height: 1.8,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Bangla translation
                      if (!hideBangla)
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

                      // Bookmark + 3 Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked
                                  ? Colors.orange
                                  : Colors.grey[600],
                            ),
                            onPressed: () => _toggleBookmark(index, ayahNumber),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              setState(() {
                                expandedAyahIndex = isExpanded ? null : index;
                              });
                            },
                          ),
                        ],
                      ),

                      // Expanded menu
                      if (isExpanded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  _shareAyah(verse.text, verse.translation),
                              icon: const Icon(Icons.share, size: 18),
                              label: const Text("Share"),
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  _copyAyah(verse.text, verse.translation),
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text("Copy"),
                            ),
                            TextButton.icon(
                              onPressed: () => _reportAyah(ayahNumber),
                              icon: const Icon(Icons.flag, size: 18),
                              label: const Text("Report"),
                            ),
                          ],
                        ),

                      if (index != widget.surah.verses.length - 1)
                        AnimatedGradientDivider(controller: _controller),
                    ],
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

/// 🌟 Animated Gradient Divider
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
