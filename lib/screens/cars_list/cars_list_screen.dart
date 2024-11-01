import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/car.dart';
import 'package:car_log/screens/cars_list/widgets/car_tile_widget.dart';
import 'package:car_log/screens/cars_list/widgets/car_app_bar.dart';
import 'package:car_log/screens/cars_list/widgets/favorite_floating_action_button.dart';
import 'package:car_log/model/user.dart';

class CarsListScreen extends StatefulWidget {
  const CarsListScreen({super.key});

  @override
  _CarsListScreenState createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
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
      body: Consumer<CarService>(
        builder: (context, carService, _) {
          return StreamBuilder<List<Car>>(
            stream: carService.cars,
            builder: (context, snapshot) {
              return _buildBodyContent(context, snapshot);
            },
          );
        },
      ),
      floatingActionButton:
          const FavoriteFloatingActionButton(routeName: '/add-car'),
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

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildError(Object? error) =>
      Center(child: Text('Error loading cars: $error'));

  Widget _buildEmpty() => const Center(child: Text('No cars found'));

  Widget _buildCarList(List<Car> sortedCars) {
    return ListView.builder(
      itemCount: sortedCars.length,
      itemBuilder: (context, index) {
        final car = sortedCars[index];
        return Consumer<UserService>(
          builder: (context, userService, _) {
            final isFavorite = currentUser != null &&
                userService.isFavoriteCar(currentUser!, car.id);
            return CarTileWidget(
              car: car,
              isFavorite: isFavorite,
              onToggleFavorite: () => _toggleFavorite(car.id),
              onNavigate: () => Navigator.pushNamed(context, '/car-navigation',
                  arguments: car),
            );
          },
        );
      },
    );
  }

  void _toggleFavorite(String carId) async {
    final userService = Provider.of<UserService>(context, listen: false);

    if (currentUser != null) {
      await userService.toggleFavoriteCar(currentUser!, carId);
      setState(() {});
    }
  }

  List<Car> _sortCars(List<Car> cars) {
    final userService = Provider.of<UserService>(context, listen: false);

    final favoriteCars = cars
        .where((car) =>
            currentUser != null &&
            userService.isFavoriteCar(currentUser!, car.id))
        .toList();
    final otherCars = cars
        .where((car) =>
            currentUser == null ||
            !userService.isFavoriteCar(currentUser!, car.id))
        .toList();
    return favoriteCars..addAll(otherCars);
  }
}
