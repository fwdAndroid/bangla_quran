import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: ArabicText(
          languageProvider.localizedStrings["Tasbeeh Counter"] ??
              'Tasbeeh Counter',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ArabicText(
              languageProvider.localizedStrings["Count"] ?? 'Count',
              style: TextStyle(fontSize: 24),
            ),
            ArabicText(
              '$counter',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: incrementCounter,
              child: ArabicText(
                languageProvider.localizedStrings["Tasbeeh"] ?? 'Tasbeeh',
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
            TextButton(
              onPressed: resetCounter,
              child: ArabicText(
                languageProvider.localizedStrings["Reset"] ?? 'Reset',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
