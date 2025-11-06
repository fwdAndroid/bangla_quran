import 'package:bangla_quran/model/hadith_model.dart';
import 'package:bangla_quran/services/hadith_service.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';

enum Language { english, bangla }

class ZikrTab extends StatefulWidget {
  const ZikrTab({super.key});

  @override
  State<ZikrTab> createState() => _ZikrTabState();
}

class _ZikrTabState extends State<ZikrTab> {
  Language selectedLanguage = Language.english;

  final HadithService _service = HadithService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hadith>>(
      future: _service.fetchHadiths(book: 'sahih-bukhari', limit: 15),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Hadiths found"));
        }

        final hadiths = snapshot.data!;
        return ListView.builder(
          itemCount: hadiths.length,
          itemBuilder: (context, index) {
            final h = hadiths[index];
            return Card(
              color: Colors.white.withOpacity(0.95),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic Text
                    ArabicText(
                      h.arabic,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Translation
                    ArabicText(
                      selectedLanguage == Language.english
                          ? h.english
                          : h.arabic,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Reference
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ArabicText(
                        h.reference,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
