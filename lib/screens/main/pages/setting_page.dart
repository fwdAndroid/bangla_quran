import 'package:flutter/material.dart';
import 'package:quranapp/screens/setting/edit_profile.dart';
import 'package:quranapp/screens/setting/language_setting.dart';
import 'package:quranapp/widgets/logout_widget.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/logo.png", height: 150),
            ),
            const Text(
              'Learn Quran',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3B2A),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => EditProfile()),
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text("Edit Profile"),
                leading: Icon(Icons.person, color: Color(0xFF1D3B2A)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => ChangeLangage()),
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text("Change Language"),
                leading: Icon(Icons.language, color: Color(0xFF1D3B2A)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  shareApp();
                },
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text("Invite Friends"),
                leading: Icon(Icons.share, color: Color(0xFF1D3B2A)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutWidget();
                    },
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text("Logout"),
                leading: Icon(Icons.logout, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void shareApp() {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.example.yourapp";
    Share.share("Hey, check out this amazing app: $appLink");
  }
}
