import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quranapp/screens/main/main_dashboard.dart';
import 'package:quranapp/services/auth_services.dart';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Learn Quran',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3B2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
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
                          child: Text(
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
                          child: Text(
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Email address"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Username only in Register
              if (!isLogin) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Username"),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Your username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              /// Password
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Password"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              if (isLogin)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Forgot password?",
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
                    child: Text(
                      isLogin ? "Sign in" : "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Other sign in options"),
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
