import 'package:car_log/model/expense.dart';
import 'package:car_log/screens/car_expenses/widgets/car_expense_add_dialog.dart';
import 'package:car_log/screens/car_expenses/widgets/expenses_list.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/expense_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/stream_custom_builder.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';

const _TITLE = 'Car Expenses';

class CarExpensesScreen extends StatefulWidget {
  const CarExpensesScreen({super.key});

  @override
  State<CarExpensesScreen> createState() => _CarExpensesScreenState();
}

class _CarExpensesScreenState extends State<CarExpensesScreen> {
  final CarService carService = get<CarService>();
  Expense? expense = ExpenseService().activeExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(title: _TITLE, userDetailRoute: Routes.userDetail),
      body: StreamCustomBuilder<List<Expense>>(
          stream: ExpenseService().getExpenses(carService.activeCar.id),
          builder: (context, expenses) {
            return ExpensesList(expenses: expenses);
          }),
      floatingActionButton: CarExpenseAddDialog(),
    );
  }
}
