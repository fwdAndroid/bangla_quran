import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/screens/audio/audio_quran.dart';
import 'package:bangla_quran/screens/drawer_pages/live_chat.dart';
import 'package:bangla_quran/screens/drawer_pages/allah_names.dart';
import 'package:bangla_quran/screens/drawer_pages/tasbeeh_counter.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  void shareApp() {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.example.yourapp";
    Share.share("Hey, check out this amazing Quran app: $appLink");
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Drawer(
      elevation: 8,
      child: Container(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Image.asset("assets/logo.png", height: 200),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    children: [
                      _buildDrawerItem(
                        icon: Icons.library_music,
                        text: "অডিও কুরআন",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AudioQuran(),
                          ),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.chat,
                        text: "লাইভ চ্যাট",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiveChat(),
                          ),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.menu_book_rounded,
                        text: "আল্লাহর নামসমূহ",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllahNamesScreen(),
                          ),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.fingerprint_rounded,
                        text: "তাসবিহ কাউন্টার",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasbeehCounterPage(),
                          ),
                        ),
                      ),
                      const Divider(height: 25),
                      _buildDrawerItem(
                        icon: Icons.share,
                        text: "বন্ধুদের আমন্ত্রণ জানান",
                        iconColor: Colors.teal,
                        onTap: shareApp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.green,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(icon, color: iconColor, size: 26),
            title: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
