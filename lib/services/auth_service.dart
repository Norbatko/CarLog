import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/model/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final DatabaseService _databaseService;

  AuthService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<String?> authUser(LoginData data) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        await _databaseService.getUserById(userId);
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signupUser(SignupData data) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      return userCredential.user?.uid; // Return only the userId
    } on firebase_auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return "Error sending password reset email.";
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      // Retrieve the user's profile data from the database
      return await _databaseService.getUserById(firebaseUser.uid);
    }
    return null; // No user is currently logged in
  }
}
