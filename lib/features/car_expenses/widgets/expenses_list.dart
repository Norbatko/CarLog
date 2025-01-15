import 'package:car_log/model/expense.dart';
import 'package:car_log/features/car_expenses/widgets/expense_tile_widget.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatefulWidget {
  final List<Expense> expenses;

  const ExpensesList({
    super.key,
    required this.expenses,
  });

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  late List<Expense> sortedExpenses;
  final ExpenseService expenseService = get<ExpenseService>();

  void _sortExpenses() {
    widget.expenses.sort((a, b) {
      var aDate = a.date;
      var bDate = b.date;
      return aDate.compareTo(bDate);
    });
    sortedExpenses = widget.expenses;
  }

  Widget build(BuildContext context) {
    _sortExpenses();
    return sortedExpenses.isEmpty
        ? const Center(child: Text('No expenses available'))
        : ListView.builder(
            itemCount: sortedExpenses.length,
            itemBuilder: (context, index) {
              final expense = sortedExpenses[index];
              return ExpenseTileWidget(
                expense: expense,
                onNavigate: () {
                  expenseService.setActiveExpense(expense);
                  Navigator.pushNamed(
                    context,
                    Routes.expenseDetail,
                    arguments: expense,
                  );
                },
              );
            },
          );
  }
}
