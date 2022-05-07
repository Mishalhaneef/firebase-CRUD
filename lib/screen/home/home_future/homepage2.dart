// single document from id

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screen/home/home_stream/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../adduser.dart';

class HomePageDoc extends StatelessWidget {
  HomePageDoc({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All User'),
      ),
      body: FutureBuilder<Users?>(
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              if (snapshot.data == null) {
                return Message(text: 'value is ${snapshot.data}');
              }
              return Message(text: ': ${snapshot.error}');
            }

            if (snapshot.data == null) {
              return Message(text: 'value ${snapshot.data}');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final user = snapshot.data;

                return user == null
                    ? const Message(text: 'No User')
                    : buildUser(user);
              } else {
                return Loading();
              }
            } else {
              return Loading();
            }
          } on FirebaseException catch (e) {
            return Text('crashed');
          }
        },
        future: readUser(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget buildUser(Users? user) => ListTile(
      leading: CircleAvatar(child: Text('${user!.age}')),
      title: Text(user.name),
      subtitle: Text(user.sex),
    );

Future createUser({
  required String name,
  required int age,
  required String sex,
}) async {
  // Reference to document
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  // replacing previous json map to a user object

  final user = Users(
    id: docUser.id,
    name: name,
    age: age,
    sex: sex,
  );

  /// Create document and write data to Firebase
  await docUser.set(user.toJson());
  log('added');
}

Future<Users?> readUser() async {
  const id = 'NGHpkuSWtMkkNHLMuhzP';
  final docUser = FirebaseFirestore.instance.collection('users').doc(id);
  final snapshot = await docUser.get();

  if (snapshot.exists) {
    return Users.fromJson(snapshot.data()!);
  }
  return null;
}



class Message extends StatelessWidget {
  const Message({Key? key, required this.text}) : super(key: key);

  final text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
