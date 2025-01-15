import 'package:car_log/model/expense.dart';
import 'package:car_log/model/expense_model.dart';

class ExpenseService {
  final ExpenseModel expenseModel;
  Expense? _activeExpense;

  ExpenseService._private(this.expenseModel);

  static final ExpenseService _instance =
      ExpenseService._private(ExpenseModel());

  factory ExpenseService() {
    return _instance;
  }

  Stream<List<Expense>> getExpenses(String carId) =>
      expenseModel.getExpenses(carId);

  Expense? get activeExpense => _activeExpense;

  Stream<void> addExpenses(
    String carId, {
    required ExpenseType type,
    required String userID,
    required double amount,
    required DateTime date,
  }) async* {
    Expense expense = Expense(
      id: '',
      userId: userID,
      type: type,
      amount: amount,
      date: date,
    );

    yield* expenseModel.addExpense(carId, expense);
  }

  Stream<void> deleteExpense(String carId, String expenseId) async* {
    yield* expenseModel.deleteExpense(carId, expenseId);
  }

  Stream<void> updateExpense(
      String carId, String expenseId, Expense expense) async* {
    yield* expenseModel.updateExpense(carId, expenseId, expense);
  }

  void setActiveExpense(Expense expense) {
    _activeExpense = expense;
  }

  Expense? getActiveExpense() {
    return _activeExpense;
  }
}
