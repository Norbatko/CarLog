import 'package:car_log/base/filters/expense/expense_type_filter.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseFilterDialog extends StatefulWidget {
  final Set<String> selectedExpenseTypes;
  final List<Expense> expenses;

  const ExpenseFilterDialog({
    super.key,
    required this.selectedExpenseTypes,
    required this.expenses,
  });

  @override
  _ExpenseFilterDialogState createState() => _ExpenseFilterDialogState();
}

class _ExpenseFilterDialogState extends State<ExpenseFilterDialog> {
  late Set<String> _expenseTypes;

  @override
  void initState() {
    super.initState();
    _expenseTypes = Set<String>.from(widget.selectedExpenseTypes);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Filter Expenses',
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseTypeFilter(
              expenses: widget.expenses,
              selectedExpenseTypes: widget.selectedExpenseTypes,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _expenseTypes = newSelection;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(null); // Close dialog without applying filters
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'expenseTypes': _expenseTypes.toList(),
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
