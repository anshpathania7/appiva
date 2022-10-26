import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static final AuthRepository _singleton = AuthRepository._internal();
  factory AuthRepository() {
    return _singleton;
  }
  AuthRepository._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> loginWithGoogle() async {
    try {
      await _firebaseAuth.signInWithProvider(GoogleAuthProvider());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
