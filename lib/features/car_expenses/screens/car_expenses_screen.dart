import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/widgets/car_expense_add_dialog.dart';
import 'package:car_log/features/car_expenses/widgets/expense_icon_widget.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:car_log/base/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart';  // Import constants

class CarExpensesScreen extends StatelessWidget {
  final CarService carService = get<CarService>();
  final ExpenseService expenseService = get<ExpenseService>();

  CarExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCar = carService.activeCar;

    return Scaffold(
      appBar: ApplicationBar(title: TITLE, userDetailRoute: Routes.userDetail),
      body: StreamCustomBuilder<List<Expense>>(
        stream: expenseService.getExpenses(activeCar.id),
        builder: (context, expenses) {
          return _buildExpenseList(expenses, context);
        },
      ),
      floatingActionButton: CarExpenseAddDialog(),
    );
  }

  Widget _buildExpenseList(List<Expense> expenses, BuildContext context) {
    if (expenses.isEmpty) return _buildEmptyState(context);

    return ListView.builder(
      itemCount: expenses.length,
      padding: const EdgeInsets.symmetric(vertical: SECTION_PADDING),
      itemBuilder: (context, index) {
        return _buildExpenseCard(context, expenses[index]);
      },
    );
  }

  Widget _buildExpenseCard(BuildContext context, Expense expense) {
    return Card(
      margin: CARD_MARGIN,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CARD_RADIUS),
      ),
      elevation: CARD_ELEVATION,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.expenseDetail,
            arguments: expense,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(LOTTIE_ANIMATION_PATH, width: 220, height: 220),
          SIZED_BOX_HEIGHT_24,
          NO_EXPENSES_TEXT,
          SIZED_BOX_HEIGHT_10,
          ADD_EXPENSE_TEXT,
        ],
      ),
    );
  }
}
