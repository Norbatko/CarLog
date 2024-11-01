import 'package:flutter/material.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/car.dart';
import 'package:car_log/screens/cars_list/widgets/car_tile_widget.dart';
import 'package:car_log/screens/cars_list/widgets/car_app_bar.dart';
import 'package:car_log/screens/cars_list/widgets/favorite_floating_action_button.dart';
import '../../model/user.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({
    super.key,
    required this.authService,
    required this.userService,
    required this.carService,
  });

  final AuthService authService;
  final UserService userService;
  final CarService carService;

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  User? currentUser;
  double _opacity = 0.0; // Start with full transparency

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _triggerFadeIn(); // Start the fade-in animation
  }

  Future<void> _loadCurrentUser() async {
    final user = await widget.authService.getCurrentUser();
    if (user != null) {
      currentUser = await widget.userService.getUserData(user.id);
      setState(() {}); // Update UI after loading user data
    }
  }

  void _triggerFadeIn() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 10), // Fade-in duration
      child: Scaffold(
        appBar: const CarAppBar(title: 'Car List', userDetailRoute: '/user/detail'),
        body: StreamBuilder<List<Car>>(
          stream: widget.carService.cars,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading cars: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No cars found'));
            } else {
              final sortedCars = _sortCars(snapshot.data!);
              return ListView.builder(
                itemCount: sortedCars.length,
                itemBuilder: (context, index) {
                  final car = sortedCars[index];
                  return CarTileWidget(
                    car: car,
                    isFavorite: currentUser != null &&
                        widget.userService.isFavoriteCar(currentUser!, car.id),
                    onToggleFavorite: () => _toggleFavorite(car.id),
                    onNavigate: () =>
                        Navigator.pushNamed(context, '/car-navigation', arguments: car),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: const FavoriteFloatingActionButton(routeName: '/add-car'),
      ),
    );
  }

  void _toggleFavorite(String carId) async {
    if (currentUser != null) {
      await widget.userService.toggleFavoriteCar(currentUser!, carId);
      setState(() {});
    }
  }

  List<Car> _sortCars(List<Car> cars) {
    final favoriteCars = cars
        .where((car) => currentUser != null && widget.userService.isFavoriteCar(currentUser!, car.id))
        .toList();
    final otherCars = cars
        .where((car) => currentUser == null || !widget.userService.isFavoriteCar(currentUser!, car.id))
        .toList();
    return favoriteCars..addAll(otherCars);
  }
}
