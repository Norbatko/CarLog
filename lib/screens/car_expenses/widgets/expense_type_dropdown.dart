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
      decoration: const InputDecoration(labelText: 'Expense Type'),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        value: selectedExpenseType,
        onChanged: onChanged,
        items: expenseTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      )),
    );
  }
}
