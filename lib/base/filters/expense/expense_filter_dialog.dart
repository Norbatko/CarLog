import 'package:car_log/base/filters/expense/amount_range_filter.dart';
import 'package:car_log/base/filters/expense/date_range_filter.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;
  double? _minAmount;
  double? _maxAmount;

  @override
  void initState() {
    super.initState();
    _expenseTypes = Set<String>.from(widget.selectedExpenseTypes);
    final amounts = widget.expenses.map((e) => e.amount).toList();
    _minAmount =
        amounts.isNotEmpty ? amounts.reduce((a, b) => a < b ? a : b) : 0.0;
    _maxAmount =
        amounts.isNotEmpty ? amounts.reduce((a, b) => a > b ? a : b) : 0.0;
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
              selectedExpenseTypes: _expenseTypes,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _expenseTypes = newSelection;
                });
              },
            ),
            const SizedBox(height: 16),
            DateRangeFilter(
              initialStartDate: _startDate,
              initialEndDate: _endDate,
              onDateRangeChanged: (startDate, endDate) {
                setState(() {
                  _startDate = startDate;
                  _endDate = endDate;
                });
              },
            ),
            const SizedBox(height: 16),
            AmountFilter(
              minAmount: _minAmount!,
              maxAmount: _maxAmount!,
              onAmountRangeChanged: (minAmount, maxAmount) {
                setState(() {
                  _minAmount = minAmount;
                  _maxAmount = maxAmount;
                });
              },
            ),
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
              'startDate': _startDate,
              'endDate': _endDate,
              'minAmount': _minAmount,
              'maxAmount': _maxAmount,
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
