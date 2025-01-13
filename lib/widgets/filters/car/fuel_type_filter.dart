import 'package:car_log/model/car.dart';
import 'package:flutter/material.dart';

class FuelTypeFilter extends StatelessWidget {
  final Set<String> selectedFuelTypes;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<Car> cars;

  const FuelTypeFilter({
    super.key,
    required this.selectedFuelTypes,
    required this.onSelectionChanged,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueFuelTypes = cars.map((car) => car.fuelType).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fuel Types',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Wrap(
          spacing: 8.0, // Space between chips
          runSpacing: 4.0,
          children: uniqueFuelTypes.map((fuelType) {
            return _buildFilterChip(fuelType);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedFuelTypes.contains(label),
      onSelected: (isSelected) {
        final newSelection = Set<String>.from(selectedFuelTypes);
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
