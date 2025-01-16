import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart';
import 'package:car_log/features/car_expenses/widgets/expense_icon_widget.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;

  const ExpenseListTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final expenseService = get<ExpenseService>();
    return Card(
      margin: CARD_MARGIN,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CARD_RADIUS),
      ),
      elevation: CARD_ELEVATION,
      child: InkWell(
        onTap: () {
          expenseService.setActiveExpense(expense);
          Navigator.pushNamed(
            context,
            Routes.expenseDetail,
          );
        },
        borderRadius: BorderRadius.circular(CARD_RADIUS),
        child: Padding(
          padding: CARD_PADDING,
          child: Row(
            children: [
              // Keep the date icon as it was
              _buildAlignedExpenseInfo(
                icon: Icons.date_range,
                label: DateFormat(DATE_FORMAT).format(expense.date),
                alignment: TextAlign.start,
              ),
              // Use ExpenseIconWidget for dynamic expense category icon
              _buildAlignedExpenseInfo(
                iconWidget: ExpenseIconWidget(expenseType: expense.type),
                label: expenseTypeToString(expense.type),
                alignment: TextAlign.center,
              ),
              // Keep the money icon as it was for the amount
              _buildAlignedExpenseInfo(
                icon: Icons.attach_money,
                label: '${expense.amount.toStringAsFixed(0)}',
                alignment: TextAlign.end,
                iconColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlignedExpenseInfo({
    IconData? icon,
    Widget? iconWidget,
    required String label,
    TextAlign alignment = TextAlign.start,
    Color iconColor = Colors.blue,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: ICON_BOX_WIDTH,
            child: iconWidget ?? Icon(icon, size: ICON_SIZE, color: iconColor),
          ),
          const SizedBox(width: SPACING_BETWEEN_ICON_TEXT),
          Expanded(
            child: Text(
              label,
              style: TEXT_STYLE,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
