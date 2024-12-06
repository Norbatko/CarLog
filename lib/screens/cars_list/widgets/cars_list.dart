import 'package:car_log/model/car.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/widgets/car_tile_widget.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/stream_custom_builder.dart';
import 'package:flutter/material.dart';

class CarsList extends StatefulWidget {
  final List<Car> cars;

  const CarsList({
    super.key,
    required this.cars,
  });

  @override
  State<CarsList> createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  late List<Car> sortedCars;
  final CarService carService = get<CarService>();
  final UserService userService = get<UserService>();
  final AuthService authService = get<AuthService>();
  Stream<User?>? currentUserStream;

  @override
  void initState() {
    super.initState();
    currentUserStream = authService.getCurrentUser().asyncExpand((user) {
      if (user != null) {
        return userService.getLoggedInUserData(user.id);
      }
      return Stream.value(null);
    });
  }

  void _sortCars() {
    final favoriteCars = widget.cars
        .where((car) => userService.isFavoriteCar(car.id))
        .toList();
    final otherCars = widget.cars
        .where((car) =>  !userService.isFavoriteCar(car.id))
        .toList();
    sortedCars = favoriteCars..addAll(otherCars);
  }

  void _toggleFavorite(String carId) async {
      await userService.toggleFavoriteCar(carId);
      setState(() {
        _sortCars(); // Re-sort after toggling favorite
      });
  }

  Widget build(BuildContext context) {
    return StreamCustomBuilder<User?>(
      stream: userService.userStream,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const Center(child: Text('No user data available'));
        }
        _sortCars();
        return sortedCars.isEmpty
            ? const Center(child: Text('No cars available'))
            : ListView.builder(
          itemCount: sortedCars.length,
          itemBuilder: (context, index) {
            final car = sortedCars[index];
            final isFavorite = currentUser.favoriteCars.contains(car.id);
            return CarTileWidget(
              car: car,
              isFavorite: isFavorite,
              onToggleFavorite: () => _toggleFavorite(car.id),
              onNavigate: () {
                carService.setActiveCar(car);
                Navigator.pushNamed(
                  context,
                  Routes.carDetail,
                  arguments: car,
                );
              },
            );
          },
        );
      },
    );
  }
}
