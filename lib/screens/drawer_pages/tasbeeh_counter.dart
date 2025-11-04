import 'package:flutter/material.dart';

class TasbeehCounterPage extends StatefulWidget {
  @override
  _TasbeehCounterPageState createState() => _TasbeehCounterPageState();
}

class _TasbeehCounterPageState extends State<TasbeehCounterPage> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasbeeh Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count', style: TextStyle(fontSize: 24)),
            Text(
              '$counter',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: incrementCounter,
              child: Text('Tasbeeh'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
            TextButton(
              onPressed: resetCounter,
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
