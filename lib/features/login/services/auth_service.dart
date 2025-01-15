import 'package:car_log/base/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/base/models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final UserService _userService;

  AuthService({required UserService userService})
      : _userService = userService;
  Stream<String?> authUser(LoginData data) async* {
    try {
      final firebase_auth.UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        _userService.getUserData(userId).listen((_) {});
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
        return _userService.getUserData(firebaseUser.uid).first;
      }
      return null;
    });
  }
}
