import 'package:bangla_quran/provider/font_provider.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontSettingsScreen extends StatelessWidget {
  final List<String> fonts = ['Tahoma', 'Amiri'];

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSettingsProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: ArabicText("Font Setting"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 24),

                // Display Options Header
                ArabicText(
                  "Display Options",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchListTile(
                  title: const Text("Show Arabic"),
                  value: fontProvider.showArabic,
                  onChanged: (value) => fontProvider.toggleShowArabic(value),
                ),
                SwitchListTile(
                  title: const Text("Show Bangla"),
                  value: fontProvider.showBangla,
                  onChanged: (value) => fontProvider.toggleShowBangla(value),
                ),

                const SizedBox(height: 16),

                // Font Selection Header
                ArabicText(
                  languageProvider
                          .localizedStrings["Choose the type of Arabic font"] ??
                      "Choose the type of Arabic font",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Font Selection (Horizontal Switches)
                Row(
                  children: fonts.map((font) {
                    final isSelected = fontProvider.arabicFontFamily == font;
                    return Expanded(
                      child: SwitchListTile(
                        title: ArabicText(
                          font,
                          style: TextStyle(fontFamily: font),
                        ),
                        value: isSelected,
                        onChanged: (value) {
                          if (value) {
                            fontProvider.updateFontFamily(font);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Font Size Header
                ArabicText(
                  languageProvider.localizedStrings["Font Size"] ?? "Font Size",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Font Size Slider
                Slider(
                  value: fontProvider.fontSize,
                  min: 18,
                  max: 48,
                  divisions: 10,
                  label: fontProvider.fontSize.toInt().toString(),
                  onChanged: (size) {
                    fontProvider.updateFontSize(size);
                  },
                ),
                Center(
                  child: ArabicText(
                    "${fontProvider.fontSize.toInt()} px",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 16),

                // Reset Button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: ArabicText(
                      languageProvider
                              .localizedStrings["Restore default settings"] ??
                          "Restore default settings",
                    ),
                    onPressed: () {
                      fontProvider.updateFontFamily('Amiri');
                      fontProvider.updateFontSize(24.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: ArabicText(
                            languageProvider
                                    .localizedStrings["Default settings have been restored"] ??
                                "Default settings have been restored",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
