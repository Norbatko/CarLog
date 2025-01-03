import 'package:car_log/services/expense_service.dart';
import 'package:car_log/services/receipt_service.dart';
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
    get.registerSingleton<ExpenseService>(ExpenseService());
    get.registerSingleton<ReceiptService>(ReceiptService());

    get.registerLazySingleton<AuthService>(
      () => AuthService(databaseService: get<DatabaseService>()),
    );

    get.registerLazySingleton<UserService>(
      () => UserService(
        databaseService: get<DatabaseService>(),
        userModel: get<UserModel>(),
      ),
    );

    get.registerLazySingleton<CarService>(
      () => CarService(),
    );

    get.registerSingleton<ThemeProvider>(
      ThemeProvider(ThemeData.light()),
    );
  }
}
