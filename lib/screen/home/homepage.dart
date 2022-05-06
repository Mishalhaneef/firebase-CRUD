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
      body: StreamBuilder<List<Users>>(
        initialData: null,
        stream: readUsers(),
        builder: (context, snapshot) {
          try {
            log('no error on first hand');
            if (snapshot.hasError) {
              return const Center(
                child: Text('something went wrong'),
              );
            } else if (snapshot.data == null) {
              return const Text('No User Found');
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
          } on FirebaseException catch (e) {
            log('Error caught : $e');
            return const Text('Server Crashed');
          }
        },
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

Widget buildUsers(Users user) => ListTile(
      leading: CircleAvatar(child: Text('${user.age}')),
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

Stream<List<Users>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

// user object class
class Users {
  String id;
  final String name;
  final int age;
  final String sex;

  Users({
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

  static Users fromJson(Map<String, dynamic> json) => Users(
        age: json['age'],
        id: json['id'],
        name: json['name'],
        sex: json['sex'],
      );
}
