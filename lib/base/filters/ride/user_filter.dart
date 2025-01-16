import 'package:car_log/base/models/car.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:flutter/material.dart';

class UserFilter extends StatelessWidget {
  final Set<String> selectedUsers;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<Ride> rides;

  const UserFilter({
    super.key,
    required this.onSelectionChanged,
    required this.selectedUsers,
    required this.rides,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueRidesUsers =
        rides.map((ride) => ride.userName.trim()).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Users',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Wrap(
          spacing: 8.0, // Space between chips
          runSpacing: 4.0,
          children: uniqueRidesUsers.map((userName) {
            return _buildFilterChip(userName);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedUsers.contains(label),
      elevation: 3,
      pressElevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onSelected: (isSelected) {
        final newSelection = Set<String>.from(selectedUsers);
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
