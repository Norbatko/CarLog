import 'package:car_log/widgets/loader/circular_car_loader_indicator.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'widgets/cars_list.dart';

import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/widgets/car_add_dialog.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/car.dart';
import 'package:car_log/services/Routes.dart';

class CarsListScreen extends StatelessWidget {
  CarsListScreen({super.key});
  final AuthService _authService = get<AuthService>();
  final CarService _carService = get<CarService>();
  final UserService _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    final currentUserStream = _loadCurrentUser(_authService, _userService);
    final combinedStream =
        Rx.combineLatest2<User?, List<Car>, Map<String, dynamic>>(
      currentUserStream,
      _carService.cars,
      (currentUser, cars) => {
        'currentUser': currentUser,
        'cars': cars,
      },
    );

    return Scaffold(
      appBar: const ApplicationBar(
        title: 'Car List',
        userDetailRoute: Routes.userDetail,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: combinedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularCarLoaderIndicator();
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error);
          }
          final cars = snapshot.data?['cars'] as List<Car>? ?? [];

          return CarsList(cars: cars);
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

  Widget _buildError(Object? error) =>
      Center(child: Text('Error loading cars: $error'));
}
