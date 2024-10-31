import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('users');

  Future<String?> _authUser(LoginData data) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        await _fetchUserData(userId);  // Retrieve user profile from Realtime DB
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final snapshot = await _dbRef.child(uid).get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<String, dynamic>;
        print('User Data: $userData');
      } else {
        print("No user data found for uid: $uid");
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        await _dbRef.child(userId).set({
          "email": data.name,
          "name": "New User", // Default value; adjust as needed
          "phoneNumber": "",  // Default value; adjust as needed
          "login": data.name?.split('@')[0] ?? "",
          "uid": userId,
          "favoriteCars": []  // Example empty list; adjust as needed
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await _auth.sendPasswordResetEmail(email: name);
      return null;
    } catch (e) {
      return "Error sending password reset email.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'YourApp',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: Colors.blue,
      ),
    );
  }
}
