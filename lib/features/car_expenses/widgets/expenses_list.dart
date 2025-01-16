import 'package:car_log/base/filters/car/car_filter_dialog.dart';
import 'package:car_log/base/filters/expense/expense_filter_dialog.dart';
import 'package:car_log/base/filters/name_filter.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart';
import 'package:car_log/features/car_expenses/widgets/expense_list_tile.dart';
import 'package:flutter/material.dart';
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
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    _applyFilters();
    // If the filtered list is empty, show the search bar and "No users available"
    if (filteredExpenses.isEmpty && _searchQuery.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NameFilter(
                  hintText: "Name or License Plate",
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
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
                hintText: "Name or License Plate",
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
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
        expenses: widget.expenses,
      ),
    );

    if (result != null) {
      setState(() {
        selectedExpenseTypes = Set.from(result['expenses']);
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    filteredExpenses = widget.expenses.where((expense) {
      return (selectedExpenseTypes.isEmpty ||
              selectedExpenseTypes.contains(expense.type)) &&
          (expenseTypeToString(expense.type)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()));
    }).toList();

    filteredExpenses.sort((a, b) {
      return b.date.compareTo(a.date); // Descending order: newest dates first
    });
  }
}
