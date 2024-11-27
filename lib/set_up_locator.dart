import 'package:get_it/get_it.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/model/car_model.dart';
import 'package:car_log/model/user_model.dart';
import 'package:car_log/widgets/theme/theme_setter.dart';
import 'package:flutter/material.dart';

final get = GetIt.instance;

class SetUpLocator {
  static void init() {
    get.registerSingleton<DatabaseService>(DatabaseService());
    get.registerSingleton<CarModel>(CarModel());
    get.registerSingleton<UserModel>(UserModel());

    // AuthService depends on DatabaseService
    get.registerLazySingleton<AuthService>(
          () => AuthService(databaseService: get<DatabaseService>()),
    );

    // UserService depends on DatabaseService and UserModel
    get.registerLazySingleton<UserService>(
          () => UserService(
        databaseService: get<DatabaseService>(),
        userModel: get<UserModel>(),
      ),
    );

    // CarService depends on CarModel
    get.registerLazySingleton<CarService>(
          () => CarService(carModel: get<CarModel>()),
    );

    // ThemeProvider
    get.registerSingleton<ThemeProvider>(
      ThemeProvider(ThemeData.light()),
    );
  }
}
