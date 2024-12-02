import 'package:car_log/screens/cars_list/widgets/car_add_field_list.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';

const _EDGE_INSETS = 16.0;
const _SIZED_BOX_HEIGHT = 20.0;

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({super.key});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final CarService carService = get<CarService>();
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
  String _selectedFuelType = "Gasoline";

  final Map<String, String?> _errorMessages = {};

  @override
  void initState() {
    super.initState();
    var activeCar = carService.getActiveCar();
    _controllers.addAll({
      'Name': TextEditingController(text: activeCar.name),
      'Alias': TextEditingController(text: activeCar.alias),
      'License Plate': TextEditingController(text: activeCar.licensePlate),
      'Insurance': TextEditingController(text: activeCar.insurance),
      'Insurance Contact':
          TextEditingController(text: activeCar.insuranceContact),
      'Odometer Status (km)':
          TextEditingController(text: activeCar.odometerStatus),
      'Description': TextEditingController(text: activeCar.description),
    });
    _selectedFuelType = activeCar.fuelType;
    _selectedCarIcon = activeCar.icon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(
          title: 'Car Detail', userDetailRoute: Routes.userDetail),
      body: Padding(
        padding: const EdgeInsets.all(_EDGE_INSETS),
        child: Column(
          children: [
            CarAddFieldList(
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
            SizedBox(
              height: _SIZED_BOX_HEIGHT,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: Text("Update Car Detail"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(color: Colors.black)),
                  child: Text("Delete Car"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
