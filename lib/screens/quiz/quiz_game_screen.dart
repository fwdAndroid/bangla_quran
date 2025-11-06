import 'dart:async';

import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/screens/quiz/score_screen.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  List quizzes = [];
  List<Map<String, dynamic>> randomizedQuizzes = [];
  int currentIndex = 0;
  int score = 0;
  int? selectedOption;
  bool answered = false;

  int timeLeft = 15;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  void fetchQuizzes() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .orderBy('createdAt')
        .get();

    setState(() {
      quizzes = snapshot.docs.map((doc) => doc.data()).toList();
      randomizedQuizzes = List.from(quizzes)..shuffle(); // Randomize
      startTimer();
    });
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 15;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        t.cancel();
        showCorrectAndNext();
      }
    });
  }

  void selectOption(int index) {
    if (answered) return;

    setState(() {
      selectedOption = index;
      answered = true;
      if (selectedOption == randomizedQuizzes[currentIndex]['correctIndex']) {
        score++;
      }
    });

    Future.delayed(Duration(seconds: 1), showCorrectAndNext);
  }

  void showCorrectAndNext() {
    if (currentIndex < randomizedQuizzes.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        answered = false;
      });
      startTimer();
    } else {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ScoreScreen(score: score, total: randomizedQuizzes.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (randomizedQuizzes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: ArabicText(
            languageProvider.localizedStrings['Quiz'] ?? 'Quiz',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var quiz = randomizedQuizzes[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: ArabicText(
          'Question ${currentIndex + 1}/${randomizedQuizzes.length}',
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Circular countdown timer
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: 0),
              duration: Duration(seconds: 15),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        color: Colors.green,
                        backgroundColor: Colors.green.shade100,
                      ),
                    ),
                    ArabicText(
                      '${timeLeft}s',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              color: Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ArabicText(
                  quiz['question'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            ...List.generate(quiz['options'].length, (i) {
              Color optionColor = Colors.white;
              if (answered) {
                if (i == quiz['correctIndex'])
                  optionColor = Colors.green.shade400;
                else if (i == selectedOption && i != quiz['correctIndex'])
                  optionColor = Colors.red.shade400;
              } else if (selectedOption == i) {
                optionColor = Colors.green.shade100;
              }

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: optionColor,
                    foregroundColor: answered && i == quiz['correctIndex']
                        ? Colors.white
                        : Colors.green.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.green.shade800),
                    ),
                  ),
                  onPressed: () => selectOption(i),
                  child: ArabicText(
                    quiz['options'][i],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),
            Spacer(),
            if (!answered)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: ArabicText(
                  'Skip',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: showCorrectAndNext,
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
