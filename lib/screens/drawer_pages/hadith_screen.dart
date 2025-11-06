import 'package:bangla_quran/model/hadith_model.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/services/hadith_service.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Language { english, bangla }

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final HadithService _service = HadithService();
  Language selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: ArabicText(
          languageProvider.localizedStrings["Hadith Collection"] ??
              "Hadith Collection",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton<Language>(
            onSelected: (Language lang) {
              setState(() => selectedLanguage = lang);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Language.english,
                child: ArabicText(
                  languageProvider.localizedStrings["English"] ?? "English",
                ),
              ),
              PopupMenuItem(
                value: Language.bangla,
                child: ArabicText(
                  languageProvider.localizedStrings["Bangla"] ?? "Bangla",
                ),
              ),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: FutureBuilder<List<Hadith>>(
        future: _service.fetchHadiths(book: 'sahih-bukhari', limit: 15),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: ArabicText("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: ArabicText("No Hadiths found"));
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
      ),
    );
  }
}
