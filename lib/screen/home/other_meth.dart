// json map method
import 'package:cloud_firestore/cloud_firestore.dart';

Future createUserMethod1({required String name}) async {
  // Reference to document
  final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');

  final json = {
    'name': name,
    'age': 21,
    'sex': 'male',
  };

  /// Create document and write data to Firebase
  await docUser.set(json);
}
