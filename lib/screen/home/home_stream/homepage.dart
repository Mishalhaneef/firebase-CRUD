import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../adduser.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All User'),
      ),
      body: StreamBuilder<List<Users?>>(
        initialData: null,
        stream: readUsers(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              if (snapshot.data == null) {
                return Message(text: 'value is ${snapshot.data}');
              }
              return Message(text: ': ${snapshot.error}');
            }

            if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView(
                children: users.map(buildUsers).toList(),
              );
            } else {
              return Loading();
            }
          } on FirebaseException catch (e) {
            return Text('Server got error here : $e');
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

Widget buildUsers(Users? user) => ListTile(
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

Stream<List<Users>> readUsers() =>
    FirebaseFirestore.instance
    // collection for specifiy the collection on DB
    .collection('users')
    // snap shot to take all the document from the spcified colleciton
    .snapshots()
    // and the firebase collections return map. so converting to this
    // json data to user object
    .map((snapshot) =>
    // to convert we are converting the all snapshot documents to user object
    // there is a method to convert called [fromJson]
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
        id: json['id'] ?? 'cant retrve data',
        age: json['age'] ?? 00,
        name: json['name'] ?? 'cant retrve data',
        sex: json['sex'] ?? 'cant retrve data',
      );
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
