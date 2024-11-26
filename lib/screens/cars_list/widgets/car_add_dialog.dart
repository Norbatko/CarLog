import 'package:car_log/screens/cars_list/widgets/car_add_field.dart';
import 'package:flutter/material.dart';

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
    // Add more fields as needed
  };

  final Map<String, String?> _errorMessages = {};

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {_showAddCarDialog(context)},
      child: Icon(Icons.add),
      heroTag: 'addCarFAB',
    );
  }

  void _showAddCarDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Car'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _controllers.entries.map((entry) {
                    return CarAddField(
                      controller: entry.value,
                      errorMessage: _errorMessages[entry.key],
                      nameOfField: entry.key,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearErrorMessages();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _validateFields();
                    });
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          });
        }).then((_) {
      _clearErrorMessages();
    });
  }

  void _validateFields() {
    _clearErrorMessages();
    _controllers.forEach((field, controller) {
      controller.text.trim().isEmpty
          ? _errorMessages[field] = '$field is required'
          : _errorMessages[field] = null;
    });
  }

  void _clearErrorMessages() {
    _errorMessages.clear();
  }
}
