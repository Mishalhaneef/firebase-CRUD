import 'package:firebase_app/screen/home/home_stream/homepage.dart';
import 'package:firebase_app/screen/home/home_future/homepage2.dart';
import 'package:firebase_app/screen/launch_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screen/home/update_delete/update_delete.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      home: StreamBuilder<User?>(
        initialData: null,
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData == true) {
            return HomePageDoc();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const CircularProgressIndicator();
          }
          return const MainScreen();
        },
      ),
    );
  }
}
