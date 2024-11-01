import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/model/car_model.dart';
import 'package:car_log/model/user_model.dart'; // Make sure to import UserModel here
import 'package:car_log/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DatabaseService()),
        Provider(create: (_) => CarModel()),

        // AuthService depends on DatabaseService
        ProxyProvider<DatabaseService, AuthService>(
          update: (_, databaseService, __) => AuthService(databaseService: databaseService),
        ),

        // UserService depends on DatabaseService
        ProxyProvider<DatabaseService, UserService>(
          update: (_, databaseService, __) => UserService(databaseService: databaseService),
        ),

        // CarService depends on CarModel
        ProxyProvider<CarModel, CarService>(
          update: (_, carModel, __) => CarService(carModel: carModel),
        ),

        // Add UserModel as a direct provider
        Provider(create: (_) => UserModel()),
      ],
      child: MaterialApp(
        title: 'CarLog',
        home: const LoginScreen(),
      ),
    );
  }
}
