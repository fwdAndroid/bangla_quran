import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/provider/theme_provider.dart';
import 'package:bangla_quran/screens/setting/font_setting.dart';
import 'package:bangla_quran/screens/setting/theme_setting.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final iconColor = isDarkMode ? Colors.white : const Color(0xFF1D3B2A);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = themeProvider.cardColor;
    final backgroundColor = themeProvider.backgroundColor;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/logo.png", height: 150),
              ),
              ArabicText(
                languageProvider.localizedStrings["Al Quran"] ?? 'Al Quran',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),

              // 🌙 Edit Profile

              // 🌍 Change Language

              // 🎨 Theme Setting
              buildSettingCard(
                context,
                icon: Icons.color_lens,
                title: "Theme Setting",
                iconColor: iconColor,
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const ThemeSetting(),
                    ),
                  );
                },
              ),

              // 🔤 Font Setting
              buildSettingCard(
                context,
                icon: Icons.font_download_sharp,
                title: "Font Setting",
                iconColor: iconColor,
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => FontSettingsScreen(),
                    ),
                  );
                },
              ),

              // 🤝 Invite Friends
              buildSettingCard(
                context,
                icon: Icons.share,
                title: "Invite Friends",
                iconColor: iconColor,
                cardColor: cardColor,
                textColor: textColor,
                onTap: shareApp,
              ),

              // 🚪 Logout
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable function for ListTile
  Widget buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color textColor,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: ArabicText(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: iconColor),
      ),
    );
  }

  void shareApp() {
    const appLink =
        "https://play.google.com/store/apps/details?id=com.example.yourapp";
    Share.share("Hey, check out this amazing app: $appLink");
  }
}
