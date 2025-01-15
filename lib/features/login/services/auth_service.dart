import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/model/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final DatabaseService _databaseService;

  AuthService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Stream<String?> authUser(LoginData data) async* {
    try {
      final firebase_auth.UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        _databaseService.getUserById(userId).listen((_) {});
      }
      yield null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      yield e.message;
    }
  }

  Stream<String?> signupUser(SignupData data) async* {
    try {
      final firebase_auth.UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      yield userCredential.user?.uid;
    } on firebase_auth.FirebaseAuthException catch (e) {
      yield e.message;
    }
  }

  Stream<String?> recoverPassword(String email) async* {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      yield null;
    } catch (e) {
      yield "Error sending password reset email.";
    }
  }

  Stream<void> logOut() async* {
    try {
      await _auth.signOut();
      yield null;
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }

  Stream<User?> getCurrentUser() {
    return _auth.authStateChanges().asyncMap((firebaseUser) {
      if (firebaseUser != null) {
        return _databaseService.getUserById(firebaseUser.uid).first;
      }
      return null;
    });
  }
}
