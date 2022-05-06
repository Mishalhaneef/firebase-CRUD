import 'package:firebase_app/screen/login/login_screen.dart';
import 'package:firebase_app/screen/registration/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    const kMainTheme = Color(0xFFF0F5F8);
    const kMainblueTheme = Color(0xFFE8F1F6);
    const kLiteRose = Color(0xFFDCD5FF);
    const kHomeColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [kMainTheme, kMainblueTheme],
    );
    return Container(
      decoration: const BoxDecoration(
        gradient: kHomeColor,
      ),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                  color: kLiteRose, borderRadius: BorderRadius.circular(40)),
              child: Image.asset(
                'assets/login-image.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const WelcomeText(text: "Let's roll your"),
            const SizedBox(height: 10),
            const WelcomeText(text: "YouTube Journy Here"),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Unais academy here to help you with your new youtube career, if you wan to become a succesfull Youtuber who earns thousands of dollar permonth, let’s just roll the course and get know how it works',
                style: TextStyle(
                    fontFamily: 'Helvatica_lite',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 180, 180, 180)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      )),
                  child: const RegistrationTab(
                    color: kLiteRose,
                    text: 'Login',
                    login: true,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      )),
                  child: const RegistrationTab(
                    color: Colors.white,
                    text: 'Register',
                    login: false,
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class RegistrationTab extends StatelessWidget {
  const RegistrationTab({
    Key? key,
    required this.login,
    required this.text,
    required this.color,
  }) : super(key: key);
  final color;
  final text;
  final bool login;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 150,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        color: color,
        borderRadius: login == true
            ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: (login == true ? Colors.white : const Color(0xFF464444)),
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Color(0xFF464444),
          fontSize: 25,
          fontWeight: FontWeight.w800,
          fontFamily: 'Helvatica'),
    );
  }
}

class ModernTextField extends StatelessWidget {
  ModernTextField({
    Key? key,
    required this.text,
    // required this.controller,
  }) : super(key: key);

  late String text;
  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const kDeepBlueTheme = Color(0xFF60799A);
    const kMainblueTheme = Color(0xFFE8F1F6);
    return Padding(
      padding: const EdgeInsets.only(right: 40, left: 40),
      child: Container(
        height: 43,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kMainblueTheme,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 30, top: 0, bottom: 3),
          child: TextFormField(
            // controller: controller,
            cursorColor: kDeepBlueTheme,
            style: const TextStyle(color: kDeepBlueTheme),
            decoration: InputDecoration(
              hintText: text,
              hintStyle: TextStyle(color: kDeepBlueTheme.withAlpha(200)),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
