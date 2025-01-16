import 'package:car_log/base/filters/expense/expense_filter_dialog.dart';
import 'package:car_log/base/filters/name_filter.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart';
import 'package:car_log/features/car_expenses/widgets/expense_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ExpensesList extends StatefulWidget {
  final List<Expense> expenses;

  const ExpensesList({super.key, required this.expenses});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  late List<Expense> filteredExpenses;
  Set<String> selectedExpenseTypes = {};
  double minAmount = -1;
  double maxAmount = -1;
  DateTime? startDate = null;
  DateTime? endDate = null;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    _applyFilters();
    // If the filtered list is empty, show the search bar and "No users available"
    if (filteredExpenses.isEmpty && searchQuery.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NameFilter(
                  hintText: "Name or License Plate",
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                      _applyFilters();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.filter_alt),
                  label: Text(
                    "Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                  onPressed: _openFilterDialog,
                ),
              ),
            ],
          ),
          const Center(child: Text('No expenses found')),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: NameFilter(
                hintText: "Date, Type or Amount",
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                    _applyFilters();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.filter_alt),
                label: Text(
                  "Filters",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                ),
                onPressed: _openFilterDialog,
              ),
            ),
          ],
        ),
        Expanded(
          child: filteredExpenses.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: filteredExpenses.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: SECTION_PADDING),
                  itemBuilder: (context, index) {
                    return ExpenseListTile(expense: filteredExpenses[index]);
                  },
                ),
        )
      ],
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

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ExpenseFilterDialog(
        selectedExpenseTypes: selectedExpenseTypes,
        filteredExpenses: filteredExpenses,
        expenses: widget.expenses,
      ),
    );

    if (result != null) {
      setState(() {
        selectedExpenseTypes = result['expenseTypes'] != null
            ? Set.from(result['expenseTypes'])
            : selectedExpenseTypes;
        startDate = result['startDate'];
        endDate = result['endDate'];
        minAmount = result['minAmount'] ?? -1;
        maxAmount = result['maxAmount'] ?? -1;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    filteredExpenses = widget.expenses.where((expense) {
      return (selectedExpenseTypes.isEmpty ||
              selectedExpenseTypes
                  .contains(expenseTypeToString(expense.type))) &&
          (startDate == null || startDate!.isBefore(expense.date)) &&
          (endDate == null || endDate!.isAfter(expense.date)) &&
          (minAmount == -1 || minAmount <= expense.amount) &&
          (maxAmount == -1 || maxAmount >= expense.amount) &&
          (expenseTypeToString(expense.type)
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              expense.amount
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              DateFormat(DATE_FORMAT)
                  .format(expense.date)
                  .contains(searchQuery));
    }).toList();

    filteredExpenses.sort((a, b) {
      return b.date.compareTo(a.date); // Descending order: newest dates first
    });
  }
}
