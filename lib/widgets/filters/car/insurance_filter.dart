import 'package:car_log/model/car.dart';
import 'package:flutter/material.dart';

class InsuranceFilter extends StatelessWidget {
  final Set<String> selectedInsurance;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<Car> cars;

  const InsuranceFilter({
    super.key,
    required this.onSelectionChanged,
    required this.cars,
    required this.selectedInsurance,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueInsurances = cars
        .map((car) => car.insurance.trim())
        .where((responsiblePerson) => responsiblePerson.isNotEmpty)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fuel Types'),
        Wrap(
          spacing: 8.0, // Space between chips
          runSpacing: 4.0,
          children: uniqueInsurances.map((insurance) {
            return _buildFilterChip(insurance);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedInsurance.contains(label),
      onSelected: (isSelected) {
        final newSelection = Set<String>.from(selectedInsurance);
        if (isSelected) {
          newSelection.add(label);
        } else {
          newSelection.remove(label);
        }
        onSelectionChanged(newSelection);
      },
    );
  }
}
