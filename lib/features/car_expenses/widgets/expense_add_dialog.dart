import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/widgets/expense_add_field_list.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:string_validator/string_validator.dart';

const _ANIMATION_WIDTH = 150.0;
const _ANIMATION_HEIGHT = 150.0;

class CarExpenseAddDialog extends StatefulWidget {
  const CarExpenseAddDialog({super.key});

  @override
  State<CarExpenseAddDialog> createState() => _CarExpenseAddDialogState();
}

class _CarExpenseAddDialogState extends State<CarExpenseAddDialog> {
  final Map<String, TextEditingController> _controllers = {
    'Amount': TextEditingController(),
  };

  final CarService carService = get<CarService>();
  final ExpenseService expenseService = get<ExpenseService>();
  final UserService userService = get<UserService>();

  String _selectedExpenseType = 'Fuel';

  final Map<String, String?> _errorMessages = {};
  final Map<String, String> _expenseFields = {};
  final Map<String, ExpenseType> _expenseTypes = {
    'Fuel': ExpenseType.fuel,
    'Service': ExpenseType.service,
    'Repair': ExpenseType.repair,
    'Insurance': ExpenseType.insurance,
    'Other': ExpenseType.other,
  };

  bool _isSubmitting = false;

  void _submitForm() {
    setState(() {
      _isSubmitting = true;
    });

    expenseService
        .addExpense(carService.activeCar.id,
            type: _expenseTypes[_selectedExpenseType]!,
            userID: userService.currentUser!.id,
            amount: double.parse(_expenseFields['Amount']!),
            date: DateTime.now())
        .listen((_) {});

    Future.delayed(const Duration(seconds: 2, milliseconds: 100), () {
      _isSubmitting = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      onPressed: () => {_showAddCarDialog(context)},
      heroTag: 'addExpenseFAB',
    );
  }

  void _showAddCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: _buildDialogTitle(),
              content: _buildDialogContent(setState),
              actions: _buildDialogActions(context, setState),
            );
          },
        );
      },
    ).then((_) {
      _clearAllErrorMessages();
      _clearAllControllers();
    });
  }

  Widget _buildDialogTitle() {
    return _isSubmitting ? Text("New expense added") : Text('Add Expense');
  }

  Widget _buildDialogContent(void Function(void Function()) setState) {
    if (_isSubmitting) {
      return Lottie.asset(
        'assets/animations/add_expense.json',
        width: _ANIMATION_WIDTH,
        height: _ANIMATION_HEIGHT,
        repeat: false,
      );
    } else {
      return ExpenseAddFieldList(
        controllers: _controllers,
        selectedExpenseType: _selectedExpenseType,
        expenseTypes: _expenseTypes.keys.toList(),
        onExpenseTypeChanged: (newValue) {
          setState(() {
            _selectedExpenseType = newValue!;
          });
        },
        errorMessages: _errorMessages,
      );
    }
  }

  List<Widget> _buildDialogActions(
      BuildContext context, void Function(void Function()) setState) {
    if (_isSubmitting) {
      return [];
    } else {
      return [
        SaveOrDeleteButton(
          onPressed: () {
            setState(() {
              _validateFieldsAndSubmit();
            });
          },
          saveText: 'Submit',
        ),
        SaveOrDeleteButton(
          onPressed: () {
            Navigator.of(context).pop();
            _clearAllErrorMessages();
            _clearAllControllers();
            _selectedExpenseType = 'Fuel';
          },
          isDeleteButton: true,
          deleteText: 'Cancel',
        ),
      ];
    }
  }

  void _validateFieldsAndSubmit() {
    bool isValid = true;
    _clearAllErrorMessages();
    for (var entry in _controllers.entries) {
      if (entry.value.text.trim().isEmpty ||
          !isNumeric(entry.value.text.trim())) {
        _errorMessages[entry.key] = '${entry.key} is not a number';
        isValid = false;
      } else {
        _expenseFields[entry.key] = entry.value.text.trim();
      }
    }

    if (isValid) {
      setState(() {
        _submitForm();
      });
    }
  }

  void _clearAllErrorMessages() {
    _errorMessages.clear();
  }

  void _clearAllControllers() {
    for (final value in _controllers.values) {
      value.clear();
    }
  }
}
