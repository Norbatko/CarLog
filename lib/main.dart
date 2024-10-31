import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService(databaseService: DatabaseService());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarLog',
      home: LoginScreen(authService: authService),
    );
  }
}
