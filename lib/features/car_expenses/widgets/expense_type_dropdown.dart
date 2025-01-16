import 'package:flutter/material.dart';

class ExpenseTypeDropdown extends StatelessWidget {
  final String selectedExpenseType;
  final List<String> expenseTypes;
  final ValueChanged<String?> onChanged;

  const ExpenseTypeDropdown(
      {super.key,
      required this.selectedExpenseType,
      required this.expenseTypes,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Expense Type',
        hintText: 'Select expense type',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, // Ensures dropdown spans the full width
          value: selectedExpenseType,
          onChanged: onChanged,
          items: expenseTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
