import 'package:flutter/material.dart';

class ParaTab extends StatefulWidget {
  const ParaTab({super.key});

  @override
  State<ParaTab> createState() => _ParaTabState();
}

class _ParaTabState extends State<ParaTab> {
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
