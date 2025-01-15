import 'package:car_log/base/controllers/field_controller.dart';
import 'package:car_log/features/cars_list/widgets/car_add_field_list.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const _ANIMATION_WIDTH = 150.0;
const _ANIMATION_HEIGHT = 150.0;

class CarAddDialog extends StatefulWidget {
  const CarAddDialog({super.key});

  @override
  State<CarAddDialog> createState() => _CarAddDialogState();
}

class _CarAddDialogState extends State<CarAddDialog> {
  final Map<String, FieldController> _textControllers = {
    'Name':
        FieldController(controller: TextEditingController(), isRequired: true),
    'License Plate':
        FieldController(controller: TextEditingController(), isRequired: true),
    'Responsible Person':
        FieldController(controller: TextEditingController(), isRequired: true),
  };

  final Map<String, FieldController> _numericControllers = {
    'Insurance Contact':
        FieldController(controller: TextEditingController(), isRequired: true),
    'Odometer Status':
        FieldController(controller: TextEditingController(), isRequired: true),
  };

  final CarService carService = get<CarService>();

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

  bool _isSubmitting = false;

  void _submitForm() {
    setState(() {
      _isSubmitting = true;
    });

    carService
        .addCar(
            _carFields['Name']!,
            _selectedFuelType,
            _carFields['License Plate']!,
            _carFields['Insurance Contact']!,
            _carFields['Odometer Status']!,
            _carFields['Responsible Person']!,
            _selectedCarIcon)
        .listen((_) {});

    Future.delayed(const Duration(seconds: 2), () {
      _isSubmitting = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      onPressed: () => {_showAddCarDialog(context)},
      heroTag: 'addCarFAB',
    );
  }

  void _showAddCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: _buildDialogTitle(),
              content: _buildDialogContent(setState),
              actions: _buildDialogActions(context, setState),
            );
          },
        );
      },
    ).then((_) {
      _clearAllErrorMessages();
      _clearAllControllers();
    });
  }

  Widget _buildDialogTitle() {
    return _isSubmitting ? Text("New car added") : Text('Add Car');
  }

  Widget _buildDialogContent(void Function(void Function()) setState) {
    if (_isSubmitting) {
      return Lottie.asset(
        'assets/animations/add_car.json',
        width: _ANIMATION_WIDTH,
        height: _ANIMATION_HEIGHT,
        repeat: false,
      );
    } else {
      return CarAddFieldList(
        textControllers: _textControllers,
        numericControllers: _numericControllers,
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
      );
    }
  }

  List<Widget> _buildDialogActions(
      BuildContext context, void Function(void Function()) setState) {
    if (_isSubmitting) {
      return [];
    } else {
      return [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _clearAllErrorMessages();
            _clearAllControllers();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _validateFieldsAndSubmit();
            });
          },
          child: Text('Submit'),
        ),
      ];
    }
  }

  void _validateFieldsAndSubmit() {
    bool isValid = true;
    _clearAllErrorMessages();
    for (var entry in _textControllers.entries) {
      if (entry.value.controller.text.trim().isEmpty) {
        _errorMessages[entry.key] = entry.value.controller.text.trim().isEmpty
            ? '${entry.key} is required'
            : null;
        isValid = false;
      } else {
        _carFields[entry.key] = entry.value.controller.text.trim();
      }
    }

    for (var entry in _numericControllers.entries) {
      if (entry.value.controller.text.trim().isEmpty) {
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

  void _clearAllErrorMessages() {
    _errorMessages.clear();
  }

  void _clearAllControllers() {
    for (final value in _textControllers.values) {
      value.controller.clear();
    }

    for (final value in _numericControllers.values) {
      value.controller.clear();
    }
  }
}
