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

  int timeLeft = 24;
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
    timeLeft = 24;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
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

    Future.delayed(const Duration(seconds: 1), showCorrectAndNext);
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
          backgroundColor: const Color(0xFF0C2340),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            languageProvider.localizedStrings['Quiz'] ?? 'Quiz',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    var quiz = randomizedQuizzes[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C2340),
        automaticallyImplyLeading: false,
        title: Text(
          'Bangla Quiz',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${currentIndex + 1}/${randomizedQuizzes.length}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Timer box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.alarm, color: Colors.orangeAccent, size: 24),
                  const SizedBox(width: 6),
                  Text(
                    '$timeLeft',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Question box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0C2340),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  quiz['question'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options
            ...List.generate(quiz['options'].length, (i) {
              Color bgColor = const Color(0xFF0C2340);
              if (answered) {
                if (i == quiz['correctIndex']) {
                  bgColor = Colors.green;
                } else if (i == selectedOption && i != quiz['correctIndex']) {
                  bgColor = Colors.red;
                }
              }

              return GestureDetector(
                onTap: () => selectOption(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      quiz['options'][i],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Next / Skip button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: showCorrectAndNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  answered ? 'Next' : 'Skip',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
