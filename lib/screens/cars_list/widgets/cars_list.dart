import 'package:car_log/model/car.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/widgets/car_tile_widget.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/user_service.dart';
import 'package:flutter/material.dart';

class CarsList extends StatefulWidget {
  final List<Car> cars;
  final User? currentUser;
  final UserService userService;

  const CarsList({
    super.key,
    required this.cars,
    required this.currentUser,
    required this.userService,
  });

  @override
  State<CarsList> createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  late List<Car> sortedCars;

  @override
  void initState() {
    super.initState();
    _sortCars();
  }

  void _sortCars() {
    final favoriteCars = widget.cars
        .where((car) =>
            widget.currentUser != null &&
            widget.userService.isFavoriteCar(car.id))
        .toList();
    final otherCars = widget.cars
        .where((car) =>
            widget.currentUser == null ||
            !widget.userService.isFavoriteCar(car.id))
        .toList();
    sortedCars = favoriteCars..addAll(otherCars);
  }

  void _toggleFavorite(String carId) async {
    if (widget.currentUser != null) {
      await widget.userService.toggleFavoriteCar(carId);
      setState(() {
        _sortCars(); // Re-sort after toggling favorite
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _sortCars();
    return sortedCars.isEmpty
        ? const Center(child: Text('No cars available'))
        : ListView.builder(
            itemCount: sortedCars.length,
            itemBuilder: (context, index) {
              final car = sortedCars[index];
              final isFavorite = widget.currentUser != null &&
                  widget.userService.isFavoriteCar(car.id);
              return CarTileWidget(
                car: car,
                isFavorite: isFavorite,
                onToggleFavorite: () => _toggleFavorite(car.id),
                onNavigate: () => Navigator.pushNamed(
                  context,
                  Routes.carDetail,
                  arguments: car,
                ),
              );
            },
          );
  }
}
