import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/widgets/car_add_dialog.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/build_future_with_stream.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/car.dart';
import 'package:car_log/screens/cars_list/widgets/car_app_bar.dart';

import 'widgets/cars_list.dart';

class CarsListScreen extends StatelessWidget {
  const CarsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = get<AuthService>();
    final UserService userService = get<UserService>();
    final CarService carService = get<CarService>();

    return Scaffold(
      appBar:
      const CarAppBar(title: 'Car List', userDetailRoute: '/user/detail'),
      body: buildFutureWithStream<User?, List<Car>>(
        future: _loadCurrentUser(authService, userService),
        stream: carService.cars,
        loadingWidget: _buildLoading(),
        errorWidget: (error) => _buildError(error),
        onData: (context, currentUser, cars) =>
            CarsList(cars: cars, currentUser: currentUser, userService: userService),
      ),
      floatingActionButton: const CarAddDialog(),
    );
  }

  Future<User?> _loadCurrentUser(
      AuthService authService, UserService userService) async {
    final user = await authService.getCurrentUser();
    return (user != null)
        ?  await userService.getLoggedInUserData(user.id)
        :  null;
  }

  Widget _buildLoading() => Center(
      child: Lottie.network(
          "https://lottie.host/630f73c1-22b6-42aa-8a56-83629d3a1792/TyXDBpswR2.json"));

  Widget _buildError(Object? error) =>
      Center(child: Text('Error loading cars: $error'));
}
