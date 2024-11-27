import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/widgets/car_add_dialog.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/car.dart';
import 'package:car_log/screens/cars_list/widgets/car_tile_widget.dart';
import 'package:car_log/screens/cars_list/widgets/car_app_bar.dart';

class CarsListScreen extends StatefulWidget {
  const CarsListScreen({super.key});

  @override
  _CarsListScreenState createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  final AuthService authService = get<AuthService>();
  final UserService userService = get<UserService>();
  final CarService carService = get<CarService>();

  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await authService.getCurrentUser();

    if (user != null) {
      currentUser = await userService.getUserData(user.id);
      setState(() {}); // Refresh the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CarAppBar(title: 'Car List', userDetailRoute: '/user/detail'),
      body: StreamBuilder<List<Car>>(
        stream: carService.cars,
        builder: (context, snapshot) {
          return _buildBodyContent(context, snapshot);
        },
      ),
      floatingActionButton: CarAddDialog(),
    );
  }

  Widget _buildBodyContent(
      BuildContext context, AsyncSnapshot<List<Car>> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting
        ? _buildLoading()
        : snapshot.hasError
            ? _buildError(snapshot.error)
            : (!snapshot.hasData || snapshot.data!.isEmpty)
                ? _buildEmpty()
                : _buildCarList(_sortCars(snapshot.data!));
  }

  Widget _buildLoading() => Center(
      child: Lottie.network(
          "https://lottie.host/630f73c1-22b6-42aa-8a56-83629d3a1792/TyXDBpswR2.json"));

  Widget _buildError(Object? error) =>
      Center(child: Text('Error loading cars: $error'));

  Widget _buildEmpty() => const Center(child: Text('No cars found'));

  Widget _buildCarList(List<Car> sortedCars) {
    return ListView.builder(
      itemCount: sortedCars.length,
      itemBuilder: (context, index) {
        final car = sortedCars[index];
        final isFavorite =
            currentUser != null && userService.isFavoriteCar(car.id);
        return CarTileWidget(
          car: car,
          isFavorite: isFavorite,
          onToggleFavorite: () => _toggleFavorite(car.id),
          onNavigate: () =>
              Navigator.pushNamed(context, '/car-navigation', arguments: car),
        );
      },
    );
  }

  void _toggleFavorite(String carId) async {
    if (currentUser != null) {
      await userService.toggleFavoriteCar(carId);
      setState(() {});
    }
  }

  List<Car> _sortCars(List<Car> cars) {
    final favoriteCars = cars
        .where(
            (car) => currentUser != null && userService.isFavoriteCar(car.id))
        .toList();
    final otherCars = cars
        .where(
            (car) => currentUser == null || !userService.isFavoriteCar(car.id))
        .toList();
    return favoriteCars..addAll(otherCars);
  }
}
