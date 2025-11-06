import 'package:bangla_quran/screens/audio/audio_quran.dart';
import 'package:bangla_quran/screens/drawer_pages/hadith_screen.dart';
import 'package:bangla_quran/screens/drawer_pages/live_chat.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:bangla_quran/screens/drawer_pages/allah_names.dart';
import 'package:bangla_quran/screens/drawer_pages/tasbeeh_counter.dart';
import 'package:bangla_quran/widgets/logout_widget.dart';
import 'package:share_plus/share_plus.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 10),
            child: Image.asset("assets/logo.png", height: 150, width: 200),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: ArabicText(
              "Learn Quran",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(color: Colors.grey),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: ArabicText('Audio Quran'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AudioQuran()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.book),
            title: ArabicText('Live Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiveChat()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: ArabicText('Allah Names'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllahNamesScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.fingerprint),
            title: ArabicText('Tasbeeh Counter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasbeehCounterPage()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.book),
            title: ArabicText('Hadith'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HadithScreen()),
              );
            },
          ),
          Divider(),

          ListTile(
            onTap: () {
              shareApp();
            },
            title: ArabicText("Invite Friends"),
            leading: Icon(Icons.share, color: Color(0xFF1D3B2A)),
          ),
          Divider(),
          ListTile(
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LogoutWidget();
                },
              );
            },
            title: ArabicText("Logout"),
            leading: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void shareApp() {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.example.yourapp";
    Share.share("Hey, check out this amazing app: $appLink");
  }
}
