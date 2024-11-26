import 'package:car_log/screens/cars_list/widgets/car_add_field.dart';
import 'package:car_log/screens/cars_list/widgets/fuel_type_dropdown.dart';
import 'package:car_log/services/car_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CarAddDialog extends StatefulWidget {
  const CarAddDialog({super.key});

  @override
  State<CarAddDialog> createState() => _CarAddDialogState();
}

class _CarAddDialogState extends State<CarAddDialog> {
  final Map<String, TextEditingController> _controllers = {
    'Name': TextEditingController(),
    'Alias': TextEditingController(),
    'License Plate': TextEditingController(),
    'Insurance Contact': TextEditingController(),
    'Odometer Status': TextEditingController(),
    'Description': TextEditingController(),
  };

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

  bool _isSubmitting = false;

  void _submitForm() {
    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      _isSubmitting = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddCarDialog(context),
      child: const Icon(Icons.add),
      heroTag: 'addCarFAB',
    );
  }

  void _showAddCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialog(context),
    ).then((_) => _clearAllErrorMessages());
  }

  Widget _buildDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title:
            _isSubmitting ? const Text("New car added") : const Text('Add Car'),
        content: _isSubmitting
            ? Lottie.network(
                'https://lottie.host/8107173d-621c-4b5f-baa2-546bf1591ae3/Kz1JUIEi3K.json',
                width: 150,
                height: 150,
                repeat: false)
            : _buildFormContent(),
        actions: _isSubmitting ? [] : _buildDialogActions(context, setState),
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._buildCarFields(),
          _buildFuelTypeDropdown(setState),
          _buildCarIconSelection(setState),
        ],
      ),
    );
  }

  List<Widget> _buildCarFields() {
    return _controllers.entries.map((entry) {
      return CarAddField(
        controller: entry.value,
        errorMessage: _errorMessages[entry.key],
        nameOfField: entry.key,
      );
    }).toList();
  }

  Widget _buildFuelTypeDropdown(void Function(void Function()) setState) {
    return FuelTypeDropdown(
      selectedFuelType: _selectedFuelType,
      fuelTypes: _fuelTypes,
      onChanged: (String? newValue) {
        setState(() {
          _selectedFuelType = newValue!;
        });
      },
    );
  }

  Widget _buildCarIconSelection(void Function(void Function()) setState) {
    return Row(
      children: List.generate(_carIcons.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio(
              value: index,
              groupValue: _selectedCarIcon,
              onChanged: (value) {
                setState(() {
                  _selectedCarIcon = value as int;
                });
              },
            ),
            Icon(_carIcons[index]),
          ],
        );
      }),
    );
  }

  List<Widget> _buildDialogActions(
      BuildContext context, void Function(void Function()) setState) {
    return [
      TextButton(
        onPressed: () {
          _clearAllControllers();
          _clearAllErrorMessages();
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          setState(_validateFields);
          _submitForm();
          _clearAllControllers();
        },
        child: const Text('Submit'),
      ),
    ];
  }

  void _validateFields() {
    _clearAllErrorMessages();
    for (var entry in _controllers.entries) {
      _errorMessages[entry.key] =
          entry.value.text.trim().isEmpty ? '${entry.key} is required' : null;
    }
  }

  void _clearAllErrorMessages() {
    _errorMessages.clear();
  }

  void _clearAllControllers() {
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }
}
