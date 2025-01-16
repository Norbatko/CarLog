import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTypeFilter extends StatelessWidget {
  final Set<String> selectedExpenseTypes;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<Expense> expenses;

  const ExpenseTypeFilter({
    super.key,
    required this.onSelectionChanged,
    required this.selectedExpenseTypes,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueExpenseTypes =
        expenses.map((expense) => expense.type).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expense Types',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: uniqueExpenseTypes.map((expenseType) {
            return _buildFilterChip(expenseTypeToString(expenseType));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedExpenseTypes.contains(label),
      elevation: 3,
      pressElevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onSelected: (isSelected) {
        final newSelection = Set<String>.from(selectedExpenseTypes);
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
