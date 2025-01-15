import 'package:car_log/base/models/car_model.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/features/car_expenses/services/receipt_service.dart';
import 'package:car_log/features/ride/services/location_service.dart';
import 'package:get_it/get_it.dart';
import 'package:car_log/features/login/services/auth_service.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/car_notes/services/note_service.dart';
import 'package:car_log/features/ride/services/ride_service.dart';
import 'package:car_log/base/theme/theme_setter.dart';
import 'package:flutter/material.dart';

final get = GetIt.instance;

class SetUpLocator {
  static void init() {
    get.registerSingleton<DatabaseService>(DatabaseService());
    get.registerSingleton<CarModel>(CarModel());
    get.registerSingleton<ExpenseService>(ExpenseService());
    get.registerSingleton<ReceiptService>(ReceiptService());
    get.registerSingleton<NoteService>(NoteService());
    get.registerSingleton<RideService>(RideService());

    get.registerLazySingleton<LocationService>(() => LocationService());
    get.registerLazySingleton<AuthService>(
      () => AuthService(databaseService: get<DatabaseService>()),
    );

    get.registerLazySingleton<UserService>(
      () => UserService(
        databaseService: get<DatabaseService>(),
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
