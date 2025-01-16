import 'package:car_log/base/models/car.dart';
import 'package:car_log/base/filters/car/car_icon_filter.dart';
import 'package:car_log/base/filters/car/fuel_type_filter.dart';
import 'package:car_log/base/filters/car/insurance_filter.dart';
import 'package:car_log/base/filters/car/responsible_person_filter.dart';
import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:flutter/material.dart';

class CarFilterDialog extends StatefulWidget {
  final Set<String> selectedFuelTypes;
  final Set<String> selectedResponsiblePersons;
  final Set<int> selectedIcons;
  final Set<String> selectedInsurances;
  final List<Car> cars;

  const CarFilterDialog({
    super.key,
    required this.selectedFuelTypes,
    required this.selectedResponsiblePersons,
    required this.selectedIcons,
    required this.cars,
    required this.selectedInsurances,
  });

  @override
  _CarFilterDialogState createState() => _CarFilterDialogState();
}

class _CarFilterDialogState extends State<CarFilterDialog> {
  late Set<String> _fuelTypes;
  late Set<String> _responsiblePersons;
  late Set<int> _icons;
  late Set<String> _insurances;

  @override
  void initState() {
    super.initState();
    _fuelTypes = Set<String>.from(widget.selectedFuelTypes);
    _responsiblePersons = Set<String>.from(widget.selectedResponsiblePersons);
    _icons = Set<int>.from(widget.selectedIcons);
    _insurances = Set<String>.from(widget.selectedInsurances);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Filter Cars',
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FuelTypeFilter(
              selectedFuelTypes: _fuelTypes,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _fuelTypes = newSelection;
                });
              },
              cars: widget.cars,
            ),
            const SizedBox(height: 16),
            ResponsiblePersonFilter(
              selectedResponsiblePersons: _responsiblePersons,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _responsiblePersons = newSelection;
                });
              },
              cars: widget.cars,
            ),
            const SizedBox(height: 16),
            CarIconFilter(
              selectedIcons: _icons,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _icons = newSelection;
                });
              },
              cars: widget.cars,
            ),
            const SizedBox(height: 16),
            InsuranceFilter(
              selectedInsurance: _insurances,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _insurances = newSelection;
                });
              },
              cars: widget.cars,
            )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SaveOrDeleteButton(
              saveIcon: Icon(Icons.filter_alt),
              saveText: 'Apply',
              onPressed: () {
                Navigator.of(context).pop({
                  'fuelTypes': _fuelTypes.toList(),
                  'responsiblePersons': _responsiblePersons.toList(),
                  'insurances': _insurances.toList(),
                  'icons': _icons.toList(),
                });
              },
            ),
            SaveOrDeleteButton(
              isDeleteButton: true,
              deleteText: 'Cancel',
              onPressed: () {
                Navigator.of(context)
                    .pop(null); // Close dialog without applying filters
              },
            ),
          ],
        ),
      ],
    );
  }
}
