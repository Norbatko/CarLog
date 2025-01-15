import 'package:car_log/features/car_expenses/widgets/expense_add_field.dart';
import 'package:car_log/features/car_expenses/widgets/expense_type_dropdown.dart';
import 'package:flutter/material.dart';

class ExpenseAddFieldList extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final Map<String, String?> errorMessages;
  final String selectedExpenseType;
  final List<String> expenseTypes;
  final ValueChanged<String?> onExpenseTypeChanged;

  const ExpenseAddFieldList(
      {super.key,
      required this.controllers,
      required this.onExpenseTypeChanged,
      required this.selectedExpenseType,
      required this.expenseTypes,
      required this.errorMessages});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpenseTypeDropdown(
            selectedExpenseType: selectedExpenseType,
            expenseTypes: expenseTypes,
            onChanged: onExpenseTypeChanged,
          ),
          ...controllers.entries.map((entry) {
            return ExpenseAddField(
              controller: entry.value,
              errorMessage: errorMessages[entry.key],
              nameOfField: entry.key,
            );
          }).toList(),
        ],
      ),
    );
  }
}
