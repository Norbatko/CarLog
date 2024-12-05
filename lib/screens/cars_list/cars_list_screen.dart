import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/widgets/car_add_dialog.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/car.dart';
import 'package:car_log/services/Routes.dart';

import 'widgets/cars_list.dart';

class CarsListScreen extends StatelessWidget {
  const CarsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = get<AuthService>();
    final UserService userService = get<UserService>();
    final CarService carService = get<CarService>();

    final currentUserStream = _loadCurrentUser(authService, userService);

    return Scaffold(
      appBar: const ApplicationBar(
          title: 'Car List', userDetailRoute: Routes.userDetail),
      body: StreamBuilder<User?>(
        stream: currentUserStream,
        builder: (context, currentUserSnapshot) {
          if (currentUserSnapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else if (currentUserSnapshot.hasError) {
            return _buildError(currentUserSnapshot.error);
          }

          return StreamBuilder<List<Car>>(
            stream: carService.cars,
            builder: (context, carsSnapshot) {
              if (carsSnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoading();
              } else if (carsSnapshot.hasError) {
                return _buildError(carsSnapshot.error);
              }

              final cars = carsSnapshot.data ?? [];
              return CarsList(
                cars: cars,
              );
            },
          );
        },
      ),
      floatingActionButton: const CarAddDialog(),
    );
  }

  Stream<User?> _loadCurrentUser(
      AuthService authService, UserService userService) async* {
    final userStream = authService.getCurrentUser();
    await for (final user in userStream) {
      if (user != null) {
        yield* userService.getLoggedInUserData(user.id);
      } else {
        yield null;
      }
    }
  }

  Widget _buildLoading() => Center(
      child: Lottie.network(
          "https://lottie.host/630f73c1-22b6-42aa-8a56-83629d3a1792/TyXDBpswR2.json"));

  Widget _buildError(Object? error) =>
      Center(child: Text('Error loading cars: $error'));
}
