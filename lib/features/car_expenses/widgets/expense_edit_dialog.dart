import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/widgets/expense_type_dropdown.dart';
import 'package:flutter/material.dart';

class EditExpenseDialog extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final String selectedExpenseType;
  final List<String> expenseTypes;
  final ValueChanged<String?> onExpenseTypeChanged;
  final void Function(String, String) onSave;
  final VoidCallback onCancel;

  EditExpenseDialog({
    super.key,
    required String initialExpenseType,
    required double initialAmount,
    required DateTime initialDate,
    required this.onSave,
    required this.onCancel,
    required this.selectedExpenseType,
    required this.onExpenseTypeChanged,
    required this.expenseTypes,
  }) {
    amountController.text = initialAmount.toStringAsFixed(2);
    dateController.text = initialDate.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        "Edit Expense",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpenseTypeDropdown(
                selectedExpenseType: selectedExpenseType,
                expenseTypes: expenseTypes,
                onChanged: onExpenseTypeChanged),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                hintText: "Enter amount",
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: "Date",
                hintText: "Select date",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(dateController.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  dateController.text = pickedDate.toIso8601String();
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        SaveOrDeleteButton(
          onPressed: () {
            onSave(amountController.text, dateController.text);
          },
        ),
        SaveOrDeleteButton(
          onPressed: onCancel,
          isDeleteButton: true,
        ),
      ],
    );
  }
}
