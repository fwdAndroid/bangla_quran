import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/provider/theme_provider.dart'; // ✅ Import ThemeProvider

class ChangeLangage extends StatefulWidget {
  const ChangeLangage({super.key});

  @override
  State<ChangeLangage> createState() => _ChangeLangageState();
}

class _ChangeLangageState extends State<ChangeLangage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode; // ✅ Get theme mode

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        centerTitle: true,
        title: ArabicText(
          languageProvider.localizedStrings['Language'] ?? "Language",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: ArabicText(
                  languageProvider.localizedStrings['Select Language'] ??
                      'Select Language',
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ),

            // 🌙 Bangla
            ListTile(
              leading: Icon(
                Icons.language,
                color: isDark ? Colors.white : Colors.black,
              ),
              onTap: () {
                languageProvider.changeLanguage('bn');
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'bn'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
              title: ArabicText(
                languageProvider.localizedStrings['Bangla'] ?? "Bangla",
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),

            // 🇬🇧 English
            ListTile(
              leading: Icon(
                Icons.language,
                color: isDark ? Colors.white : Colors.black,
              ),
              onTap: () {
                languageProvider.changeLanguage('en');
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'en'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
              title: ArabicText(
                languageProvider.localizedStrings['English'] ?? "English",
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
