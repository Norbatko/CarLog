import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/widgets/expense_add_dialog.dart';
import 'package:car_log/features/car_expenses/widgets/expenses_list.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:car_log/base/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart'; // Import constants

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
          return ExpensesList(expenses: expenses);
        },
      ),
      floatingActionButton: CarExpenseAddDialog(),
    );
  }
}
