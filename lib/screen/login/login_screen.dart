import 'dart:developer';

import 'package:firebase_app/core/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 48.0, left: 48.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 48.0, left: 48.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              signIn();
              log('email ${emailController.text}');
            },
            child: const Text('Login'),
          )
        ],
      ),
    );
  }

  Future signIn() async {
    try {
      if (emailController.text.isEmpty) {
        snackBar(context, 'Enter Email');
      } else if (passwordController.text.isEmpty) {
        snackBar(context, 'Enter password');
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password') {
        snackBar(context, 'wrong-password');
      } else if (e.code == 'user-not-found') {
        snackBar(context, 'user-not-found');
      } else if (e.code == 'invalid-email') {
        snackBar(context, 'invalid-email');
      } else if(e.code == 'user-disabled'){
        snackBar(context, 'Your account is disabled');
      }
    }
  }
}
