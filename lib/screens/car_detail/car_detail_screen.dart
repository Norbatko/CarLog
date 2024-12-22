import 'package:car_log/model/controllers/field_controller.dart';
import 'package:car_log/screens/car_detail/widgets/car_delete_dialog.dart';
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
  final Map<String, FieldController> _controllers = {};

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
  final Map<String, String> _carFields = {};

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    var activeCar = carService.getActiveCar();
    _controllers.addAll({
      'Name': FieldController(
          controller: _createController(activeCar.name), isRequired: true),
      'License Plate': FieldController(
          controller: _createController(activeCar.licensePlate),
          isRequired: true),
      'Insurance': FieldController(
          controller: _createController(activeCar.insurance), isRequired: true),
      'Insurance Contact': FieldController(
          controller: _createController(activeCar.insuranceContact),
          isRequired: true),
      'Odometer Status (km)': FieldController(
          controller: _createController(activeCar.odometerStatus),
          isRequired: true),
      'Responsible Person': FieldController(
          controller: _createController(activeCar.responsiblePerson),
          isRequired: true),
      'Description': FieldController(
          controller: _createController(activeCar.description),
          isRequired: false),
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
        child: SingleChildScrollView(
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
                    _isChanged = true;
                  });
                },
                onCarIconChanged: (value) {
                  setState(() {
                    _selectedCarIcon = value as int;
                    _isChanged = true;
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
                    onPressed: _isChanged
                        ? () {
                            setState(() {
                              _validateFieldsAndSubmit();
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text("Update Car Detail"),
                  ),
                  CarDeleteDialog(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _validateFieldsAndSubmit() {
    bool isValid = true;
    _clearAllErrorMessages();
    for (var entry in _controllers.entries) {
      if (entry.value.controller.text.trim().isEmpty &&
          entry.value.isRequired) {
        _errorMessages[entry.key] = entry.value.controller.text.trim().isEmpty
            ? '${entry.key} is required'
            : null;
        isValid = false;
      } else {
        _carFields[entry.key] = entry.value.controller.text.trim();
      }
    }

    if (isValid) {
      setState(() {
        _submitForm();
      });
    }
  }

  void _submitForm() {
    _isChanged = false;
    carService
        .updateCar(
          carService.activeCar.id,
          _carFields['Name']!,
          _selectedFuelType,
          _carFields['License Plate']!,
          _carFields['Insurance']!,
          _carFields['Insurance Contact']!,
          _carFields['Odometer Status (km)']!,
          _carFields['Responsible Person']!,
          _carFields['Description']!,
          _selectedCarIcon,
        )
        .listen((_) {});
  }

  void _clearAllErrorMessages() {
    _errorMessages.clear();
  }

  TextEditingController _createController(String initialText) {
    final controller = TextEditingController(text: initialText);
    controller.addListener(() {
      setState(() {
        _isChanged = true;
      });
    });
    return controller;
  }
}
