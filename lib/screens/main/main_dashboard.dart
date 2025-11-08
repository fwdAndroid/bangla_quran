import 'dart:io';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/provider/theme_provider.dart';
import 'package:bangla_quran/screens/main/pages/memory_page.dart';
import 'package:bangla_quran/screens/main/pages/prayer_page.dart';
import 'package:bangla_quran/screens/main/pages/qibla_page.dart';
import 'package:bangla_quran/screens/main/pages/quran_screen.dart';
import 'package:bangla_quran/screens/main/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QuranScreen(),
    const MemoryPage(),
    const PrayerPage(),
    QiblaPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider == ThemeMode.dark;

    // 🎨 Theme-based color setup
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final navBarColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final selectedColor = isDarkMode
        ? Colors.tealAccent
        : const Color(0xff588B76);
    final unselectedColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitDialog(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: navBarColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
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
                  ? Image.asset(
                      "assets/Icon.png",
                      width: 25,
                      height: 25,
                      color: selectedColor,
                    )
                  : Image.asset(
                      "assets/readnocolor.png",
                      width: 25,
                      height: 25,
                      color: unselectedColor,
                    ),
              label: languageProvider.localizedStrings["Home"] ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Image.asset(
                      "assets/Group.png",
                      width: 25,
                      height: 25,
                      color: selectedColor,
                    )
                  : Image.asset(
                      "assets/Icon-1.png",
                      width: 25,
                      height: 25,
                      color: unselectedColor,
                    ),
              label:
                  languageProvider.localizedStrings["Memorize"] ?? 'Memorize',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Image.asset(
                      "assets/prayecolor.png",
                      width: 25,
                      height: 25,
                      color: selectedColor,
                    )
                  : Image.asset(
                      "assets/Icon-2.png",
                      width: 25,
                      height: 25,
                      color: unselectedColor,
                    ),
              label: languageProvider.localizedStrings["Prayer"] ?? "Prayer",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Image.asset(
                      "assets/qiblacolor.png",
                      width: 25,
                      height: 25,
                      color: selectedColor,
                    )
                  : Image.asset(
                      "assets/line-md_compass.png",
                      width: 25,
                      height: 25,
                      color: unselectedColor,
                    ),
              label: languageProvider.localizedStrings["Qibla"] ?? "Qibla",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 25,
                color: _currentIndex == 4 ? selectedColor : unselectedColor,
              ),
              label:
                  languageProvider.localizedStrings["Settings"] ?? "Settings",
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Exit App',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Text(
          'Do you want to exit the app?',
          style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(
                color: isDarkMode ? Colors.tealAccent : Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: isDarkMode ? Colors.redAccent : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
