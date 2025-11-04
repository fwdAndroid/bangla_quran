import 'package:flutter/material.dart';

class HijabTab extends StatefulWidget {
  const HijabTab({super.key});

  @override
  State<HijabTab> createState() => _HijabTabState();
}

class _HijabTabState extends State<HijabTab> {
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
