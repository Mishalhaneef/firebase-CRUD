import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appbody.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All User'),
      ),
      body: StreamBuilder<List<UserObject>>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('something went wrong'),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUsers).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: readUsers(),
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

Widget buildUsers(UserObject user) {
  log('user build');
  return ListTile(
    leading: CircleAvatar(child: Text('${user.age}')),
    title: Text(user.name),
    subtitle: Text(user.sex),
  );
}

Future createUser({
  required String name,
  required int age,
  required String sex,
}) async {
  // Reference to document
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  // replacing previous json map to a user object

  final user = UserObject(
    id: docUser.id,
    name: name,
    age: age,
    sex: sex,
  );

  /// Create document and write data to Firebase
  await docUser.set(user.toJson());
  log('added');
}

Stream<List<UserObject>> readUsers() {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => UserObject.fromJson(doc.data()),
          )
          .toList());

  return collection;
}

// user object class
class UserObject {
  String id;
  final String name;
  final int age;
  final String sex;

  UserObject({
    this.id = '',
    required this.name,
    required this.age,
    required this.sex,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'sex': sex,
      };

  static UserObject fromJson(Map<String, dynamic> json) => UserObject(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        sex: json['sex'],
      );
}
