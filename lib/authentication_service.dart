import 'package:firebase_auth/firebase_auth.dart';

class AuthentcationService {
  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthentcationService(this._firebaseAuth);

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Signed in';
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Created Account';
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }
}
