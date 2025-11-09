import 'package:bangla_quran/screens/drawer_pages/allah_names.dart';
import 'package:bangla_quran/screens/main/pages/english_quran.dart';
import 'package:bangla_quran/screens/main/pages/quran_screen.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Vertical gradient (top yellow, bottom green)
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfffed700), Color(0xff4eb250)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 0.6], // top 50% yellow, bottom 50% green
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // move title up
          child: ArabicText(
            'আল কুরআন',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        bottom: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          controller: _tabController,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'কুরআন-বাংলা'),
            Tab(text: 'কুরআন-ইংরেজি'),
            Tab(text: "আসমাউল হুসনা"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          QuranScreen(),
          QuranEnglishScreen(),
          AllahNamesScreen(),
        ],
      ),
    );
  }
}
