import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/features/login/model/sign_up_result.dart';
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

  Stream<SignUpResult> signupUser(SignupData data) async* {
    try {
      final firebase_auth.UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      yield SignUpResult.success(userCredential.user?.uid); // Success with User ID
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        yield SignUpResult.failure('This email is already in use. Please use a different email.');
      } else if (e.code == 'weak-password') {
        yield SignUpResult.failure('The password is too weak. Please choose a stronger password.');
      } else if (e.code == 'invalid-email') {
        yield SignUpResult.failure('The email address is not valid.');
      } else {
        yield SignUpResult.failure(e.message ?? 'Unknown error occurred.');
      }
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
