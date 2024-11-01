import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/screens/login/login_screen.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/model/car_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final databaseService = DatabaseService();
  final authService = AuthService(databaseService: databaseService);
  final userService = UserService(databaseService: databaseService);
  final carService = CarService(carModel: CarModel());

  runApp(MyApp(
    authService: authService,
    userService: userService,
    carService: carService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final UserService userService;
  final CarService carService;

  const MyApp({
    super.key,
    required this.authService,
    required this.userService,
    required this.carService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarLog',
      home: LoginScreen(
        authService: authService,
        userService: userService,
        carService: carService,
      ),
    );
  }
}
