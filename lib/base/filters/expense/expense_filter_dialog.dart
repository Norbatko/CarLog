import 'package:car_log/base/filters/expense/amount_range_filter.dart';
import 'package:car_log/base/filters/expense/date_range_filter.dart';
import 'package:car_log/base/filters/expense/expense_type_filter.dart';
import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseFilterDialog extends StatefulWidget {
  final Set<String> selectedExpenseTypes;
  final List<Expense> filteredExpenses;
  final List<Expense> expenses;

  const ExpenseFilterDialog({
    super.key,
    required this.selectedExpenseTypes,
    required this.filteredExpenses,
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
    final amounts = widget.filteredExpenses.map((e) => e.amount).toList();
    _minAmount =
        amounts.isNotEmpty ? amounts.reduce((a, b) => a < b ? a : b) : 0.0;
    _maxAmount =
        amounts.isNotEmpty ? amounts.reduce((a, b) => a > b ? a : b) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
            'Filter Expenses',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          SaveOrDeleteButton(
            isDeleteButton: true,
            deleteText: 'Clear all filters',
            onPressed: () {
              setState(() {
                _expenseTypes.clear();
                _startDate = null;
                _endDate = null;
                _minAmount = widget.expenses.isNotEmpty
                    ? widget.expenses
                        .map((e) => e.amount)
                        .reduce((a, b) => a < b ? a : b)
                    : 0.0;
                _maxAmount = widget.expenses.isNotEmpty
                    ? widget.expenses
                        .map((e) => e.amount)
                        .reduce((a, b) => a > b ? a : b)
                    : 0.0;
              });
              Navigator.of(context).pop({
                'expenseTypes': _expenseTypes.toList(),
                'startDate': _startDate,
                'endDate': _endDate,
                'minAmount': _minAmount,
                'maxAmount': _maxAmount,
              });
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseTypeFilter(
              expenses: widget.filteredExpenses,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SaveOrDeleteButton(
              saveText: 'Apply',
              saveIcon: Icon(Icons.filter_alt),
              onPressed: () {
                Navigator.of(context).pop({
                  'expenseTypes': _expenseTypes.toList(),
                  'startDate': _startDate,
                  'endDate': _endDate,
                  'minAmount': _minAmount,
                  'maxAmount': _maxAmount,
                });
              },
            ),
            SaveOrDeleteButton(
              isDeleteButton: true,
              deleteText: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
