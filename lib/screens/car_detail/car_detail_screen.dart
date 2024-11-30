import 'package:car_log/screens/cars_list/widgets/car_add_field_list.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({super.key});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final CarService carService = CarService();
  final Map<String, TextEditingController> _controllers = {};

  final List<String> _fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid',
    'LPG',
    'CNG',
    'Other'
  ];

  final List<IconData> _carIcons = [
    Icons.directions_car,
    Icons.directions_bus,
    Icons.local_shipping
  ];

  int _selectedCarIcon = 0;
  String _selectedFuelType = 'Gasoline';

  final Map<String, String?> _errorMessages = {};
  final Map<String, String> _carFields = {};

  @override
  void initState() {
    super.initState();
    _controllers.addAll({
      'Name': TextEditingController(text: carService.activeCar.name),
      'Alias': TextEditingController(text: carService.activeCar.alias),
      'License Plate':
          TextEditingController(text: carService.activeCar.licensePlate),
      'Insurance': TextEditingController(text: carService.activeCar.insurance),
      'Insurance Contact':
          TextEditingController(text: carService.activeCar.insuranceContact),
      'Odometer Status (km)':
          TextEditingController(text: carService.activeCar.odometerStatus),
      'Description':
          TextEditingController(text: carService.activeCar.description),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(
          title: 'Car Detail', userDetailRoute: Routes.userDetail),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CarAddFieldList(
          controllers: _controllers,
          errorMessages: _errorMessages,
          fuelTypes: _fuelTypes,
          selectedFuelType: _selectedFuelType,
          carIcons: _carIcons,
          selectedCarIcon: _selectedCarIcon,
          onFuelTypeChanged: (newValue) {
            setState(() {
              _selectedFuelType = newValue!;
            });
          },
          onCarIconChanged: (value) {
            setState(() {
              _selectedCarIcon = value as int;
            });
          },
        ),
      ),
    );
  }
}
