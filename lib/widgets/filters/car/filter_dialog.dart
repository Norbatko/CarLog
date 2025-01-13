import 'package:car_log/model/car.dart';
import 'package:car_log/widgets/filters/car/car_icon_filter.dart';
import 'package:car_log/widgets/filters/car/fuel_type_filter.dart';
import 'package:car_log/widgets/filters/car/insurance_filter.dart';
import 'package:car_log/widgets/filters/car/responsible_person_filter.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Set<String> selectedFuelTypes;
  final Set<String> selectedResponsiblePersons;
  final Set<int> selectedIcons;
  final Set<String> selectedInsurances;
  final List<Car> cars;

  const FilterDialog({
    super.key,
    required this.selectedFuelTypes,
    required this.selectedResponsiblePersons,
    required this.selectedIcons,
    required this.cars,
    required this.selectedInsurances,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
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
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(null); // Close dialog without applying filters
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'fuelTypes': _fuelTypes.toList(),
              'responsiblePersons': _responsiblePersons.toList(),
              'insurances': _insurances.toList(),
              'icons': _icons.toList(),
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
