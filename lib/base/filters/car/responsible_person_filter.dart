import 'package:car_log/base/models/car.dart';
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
        Text(
          'Responsible Persons',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Wrap(
          spacing: 8.0, // Space between chips
          runSpacing: 4.0,
          children: uniqueResponsiblePersons.map((responsiblePerson) {
            return _buildFilterChip(responsiblePerson, context);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selectedResponsiblePersons.contains(label),
      elevation: 3,
      pressElevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
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
