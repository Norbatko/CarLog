import 'package:car_log/model/car.dart';
import 'package:flutter/material.dart';

class ResponsiblePersonFilter extends StatelessWidget {
  final Set<String> selectedResponsiblePersons;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<Car> cars;

  const ResponsiblePersonFilter({
    super.key,
    required this.selectedResponsiblePersons,
    required this.onSelectionChanged,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueResponsiblePersons = cars
        .map((car) => car.responsiblePerson.trim())
        .where((responsiblePerson) => responsiblePerson.isNotEmpty)
        .toSet()
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Responsible Persons'),
        Wrap(
          spacing: 8.0, // Space between chips
          runSpacing: 4.0,
          children: uniqueResponsiblePersons.map((responsiblePerson) {
            return _buildFilterChip(responsiblePerson);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedResponsiblePersons.contains(label),
      onSelected: (isSelected) {
        final newSelection = Set<String>.from(selectedResponsiblePersons);
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
