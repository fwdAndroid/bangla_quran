import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quranapp/screens/main/pages/memory_page.dart';
import 'package:quranapp/screens/main/pages/prayer_page.dart';
import 'package:quranapp/screens/main/pages/qibla_page.dart';
import 'package:quranapp/screens/main/pages/read_page.dart';
import 'package:quranapp/screens/main/pages/setting_page.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ReadPage(), // Replace with your screen widgets
    MemoryPage(),
    PrayerPage(),
    QiblaPage(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitDialog(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xff588B76),
          selectedLabelStyle: TextStyle(color: Color(0xff588B76)),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Image.asset("assets/Icon.png", width: 25, height: 25)
                  : Image.asset(
                      "assets/readnocolor.png",
                      width: 25,
                      height: 25,
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Image.asset("assets/Group.png", width: 25, height: 25)
                  : Image.asset("assets/Icon-1.png", width: 25, height: 25),
              label: 'Memorize',
            ),

            BottomNavigationBarItem(
              label: "Prayer",
              icon: _currentIndex == 2
                  ? Image.asset("assets/prayecolor.png", width: 25, height: 25)
                  : Image.asset("assets/Icon-2.png", width: 25, height: 25),
            ),
            BottomNavigationBarItem(
              label: "Qibla",
              icon: _currentIndex == 3
                  ? Image.asset("assets/qiblacolor.png", width: 25, height: 25)
                  : Image.asset(
                      "assets/line-md_compass.png",
                      width: 25,
                      height: 25,
                    ),
            ),
            BottomNavigationBarItem(
              label: "Settings",
              icon: _currentIndex == 4
                  ? Icon(Icons.settings, size: 25, color: Color(0xff588B76))
                  : Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop(); // For Android
              } else if (Platform.isIOS) {
                exit(0); // For iOS
              }
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
