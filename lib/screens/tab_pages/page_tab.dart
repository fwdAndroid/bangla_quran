import 'package:flutter/material.dart';

class PageTab extends StatefulWidget {
  const PageTab({super.key});

  @override
  State<PageTab> createState() => _PageTabState();
}

class _PageTabState extends State<PageTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Under Development',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
