import 'package:car_log/model/car.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/features/cars_list/widgets/car_tile_widget.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/features/login/services/auth_service.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:car_log/base/filters/car/filter_dialog.dart';
import 'package:car_log/base/filters/name_filter.dart';
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
  late List<Car> filteredCars;
  final CarService carService = get<CarService>();
  final UserService userService = get<UserService>();
  final AuthService authService = get<AuthService>();
  Stream<User?>? currentUserStream;

  // Filter options
  String _searchQuery = '';
  Set<String> selectedFuelTypes = {};
  Set<String> selectedResponsiblePersons = {};
  Set<int> selectedIcons = {};
  Set<String> selectedInsurances = {};

  @override
  void initState() {
    super.initState();
    currentUserStream = authService
        .getCurrentUser()
        .asyncExpand((user) => userService.getLoggedInUserData(user?.id ?? ''));
    _applyFilters();
  }

  void _toggleFavorite(String carId) async {
    await userService.toggleFavoriteCar(carId);
    setState(_applyFilters);
  }

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(
        selectedFuelTypes: selectedFuelTypes,
        selectedResponsiblePersons: selectedResponsiblePersons,
        selectedIcons: selectedIcons,
        selectedInsurances: selectedInsurances,
        cars: widget.cars,
      ),
    );

    if (result != null) {
      setState(() {
        selectedFuelTypes = Set.from(result['fuelTypes']);
        selectedResponsiblePersons = Set.from(result['responsiblePersons']);
        selectedIcons = Set.from(result['icons']);
        selectedInsurances = Set.from(result['insurances']);
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    filteredCars = widget.cars.where((car) {
      return (selectedFuelTypes.isEmpty ||
              selectedFuelTypes.contains(car.fuelType.toLowerCase())) &&
          (selectedResponsiblePersons.isEmpty ||
              selectedResponsiblePersons
                  .contains(car.responsiblePerson.toLowerCase())) &&
          (selectedInsurances.isEmpty ||
              selectedInsurances.contains(car.insurance.toLowerCase())) &&
          (selectedIcons.isEmpty || selectedIcons.contains(car.icon)) &&
          (car.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car.licensePlate
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()));
    }).toList();

    filteredCars.sort((a, b) {
      final isAFavorite = userService.isFavoriteCar(a.id) ? 1 : 0;
      final isBFavorite = userService.isFavoriteCar(b.id) ? 1 : 0;
      return isBFavorite - isAFavorite; // Descending order: favorites first
    });
  }

  @override
  Widget build(BuildContext context) {
    // If the filtered list is empty, show the search bar and "No users available"
    if (filteredCars.isEmpty && _searchQuery.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NameFilter(
                  hintText: "Name or License Plate",
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                      _applyFilters();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.filter_alt),
                  label: Text(
                    "Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                  onPressed: _openFilterDialog,
                ),
              ),
            ],
          ),
          const Center(child: Text('No cars found')),
        ],
      );
    }

    return StreamCustomBuilder<User?>(
      stream: currentUserStream!,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const Center(child: Text('No user data available'));
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: NameFilter(
                    hintText: "Name or License Plate",
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.filter_alt),
                    label: Text(
                      "Filters",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                    ),
                    onPressed: _openFilterDialog,
                  ),
                ),
              ],
            ),
            Expanded(
              child: filteredCars.isEmpty
                  ? const Center(child: Text('No cars available'))
                  : ListView.builder(
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) {
                        final car = filteredCars[index];
                        final isFavorite =
                            currentUser.favoriteCars.contains(car.id);
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
                    ),
            ),
          ],
        );
      },
    );
  }
}
