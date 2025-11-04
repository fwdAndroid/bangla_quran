import 'package:flutter/material.dart';
import 'package:quranapp/screens/tab_pages/dua_tab.dart';
import 'package:quranapp/screens/tab_pages/zikr_tab.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Memorize'),
          bottom: TabBar(
            indicatorAnimation: TabIndicatorAnimation.linear,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 16),
            labelColor: Color(0xFF1D3B2A),
            indicatorColor: Color(0xFF1D3B2A),
            dividerColor: Colors.grey,
            tabs: [
              Tab(text: 'Dua'),
              Tab(text: 'Zikr'),
            ],
          ),
        ),
        body: TabBarView(children: [DuaTab(), ZikrTab()]),
      ),
    );
  }
}
