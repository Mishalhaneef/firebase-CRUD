import 'dart:developer';

import 'package:firebase_app/core/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            child: const Text('Register'),
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        snackBar(context, 'email-already-in-use');
      } else if (e.code == 'weak-password') {
        snackBar(context, 'Enter atleast 6 charecter');
      } else if (e.code == 'operation-not-allowed') {
        snackBar(context, 'Something went wrong connect support team');
      }
    }
  }
}
