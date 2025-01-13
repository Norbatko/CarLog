import 'package:car_log/model/car.dart';
import 'package:flutter/material.dart';

class CarIconFilter extends StatelessWidget {
  final Set<int> selectedIcons;
  final ValueChanged<Set<int>> onSelectionChanged;
  final List<Car> cars;

  const CarIconFilter({
    super.key,
    required this.selectedIcons,
    required this.onSelectionChanged,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueIconsCars = cars.map((car) => car.icon).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Car Icons',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Wrap(
          spacing: 8.0, // Space between chips
          runSpacing: 4.0,
          children: uniqueIconsCars.map((iconNumber) {
            return _buildFilterChip(getCarIcon(iconNumber), iconNumber);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(IconData icon, int value) {
    return FilterChip(
      label: Icon(icon),
      selected: selectedIcons.contains(value),
      onSelected: (isSelected) {
        final newSelection = Set<int>.from(selectedIcons);
        if (isSelected) {
          newSelection.add(value);
        } else {
          newSelection.remove(value);
        }
        onSelectionChanged(newSelection);
      },
    );
  }

  IconData getCarIcon(int icon) {
    switch (icon) {
      case 0:
        return Icons.directions_car;
      case 1:
        return Icons.directions_bus;
      case 2:
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
  }
}
