import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bangla_quran/screens/main/main_dashboard.dart';
import 'package:bangla_quran/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final AuthService _authService =
      AuthService(); // Create auth service instance
  bool isLoading = false; // Loading state

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  void _handleAuth() async {
    setState(() => isLoading = true);

    try {
      User? user;

      if (isLogin) {
        user = await _authService.signInWithEmailPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        user = await _authService.registerWithEmailPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
          usernameController.text.trim(),
        );
      }

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => isLoading = true);
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: ArabicText('Google sign-in failed: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              ArabicText(
                languageProvider.localizedStrings["Al-Quran"] ?? 'Al-Quran',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3B2A),
                ),
              ),
              const SizedBox(height: 8),
              ArabicText(
                languageProvider
                        .localizedStrings["Log in or register to\nsave your progress"] ??
                    'Log in or register to\nsave your progress',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => isLogin = true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isLogin ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isLogin
                                ? Border.all(color: Colors.black)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: ArabicText(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isLogin ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => isLogin = false);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isLogin ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: !isLogin
                                ? Border.all(color: Colors.black)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: ArabicText(
                            languageProvider.localizedStrings["Register"] ??
                                'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !isLogin ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Email Field
              Align(
                alignment: Alignment.centerLeft,
                child: ArabicText(
                  languageProvider.localizedStrings["Email address"] ??
                      "Email address",
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText:
                      languageProvider.localizedStrings["Your Email"] ??
                      "Your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Username only in Register
              if (!isLogin) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: ArabicText(
                    languageProvider.localizedStrings["Username"] ?? "Username",
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText:
                        languageProvider.localizedStrings["Your username"] ??
                        "Your username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              /// Password
              Align(
                alignment: Alignment.centerLeft,
                child: ArabicText(
                  languageProvider.localizedStrings["Password"] ?? "Password",
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText:
                      languageProvider.localizedStrings["Password"] ??
                      "Password",
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: ArabicText(
                      "? Forgot Password ",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D3B2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleAuth,
                    child: ArabicText(
                      isLogin ? "Sign in" : "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const ArabicText("Other sign in options"),
              const SizedBox(height: 10),
              SocialLoginButton(
                height: 55,
                width: 300,
                borderRadius: 20,
                mode: SocialLoginButtonMode.multi,
                buttonType: SocialLoginButtonType.google,
                onPressed: isLoading ? null : _handleGoogleSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
