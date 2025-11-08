import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bangla_quran/screens/auth/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<Offset> _logoSlideAnimation;
  late final Animation<double> _logoFadeAnimation;

  late final AnimationController _textController;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation from bottom
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start below
      end: Offset.zero, // End at center
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _logoFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Text animation from top
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start above
      end: Offset.zero, // End at center
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Start animations
    _textController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _logoController.forward();
    });

    // Navigate after splash duration
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0XFF06402B), // Pure green
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with slide + fade
              SlideTransition(
                position: _logoSlideAnimation,
                child: FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: Image.asset('assets/logo.png', height: 200),
                ),
              ),
              const SizedBox(height: 20),
              // Text with slide + fade
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: const Text(
                    'Bangla Quran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
