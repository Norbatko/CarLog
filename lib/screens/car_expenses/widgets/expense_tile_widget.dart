import 'package:car_log/model/expense.dart';
import 'package:car_log/screens/car_expenses/widgets/expense_details_widget.dart';
import 'package:car_log/screens/car_expenses/widgets/expense_icon_widget.dart';
import 'package:flutter/material.dart';

const _BORDER_RADIUS = 16.0;
const _MARGIN = 8.0;
const _PADDING = 12.0;

class ExpenseTileWidget extends StatelessWidget {
  final Expense expense;
  final VoidCallback onNavigate;

  const ExpenseTileWidget({
    super.key,
    required this.expense,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(_MARGIN),
      padding: const EdgeInsets.all(_PADDING),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(_BORDER_RADIUS),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: ListTile(
        leading: ExpenseIconWidget(expenseType: expense.type),
        title: ExpenseDetailsWidget(expense: expense),
        onTap: onNavigate,
      ),
    );
  }
}
