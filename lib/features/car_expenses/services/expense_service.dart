import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');

  Expense? _activeExpense;

  ExpenseService._private();

  static final ExpenseService _instance = ExpenseService._private();

  factory ExpenseService() => _instance;

  Stream<List<Expense>> getExpenses(String carId) {
    return carsCollection
        .doc(carId)
        .collection('expenses')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Expense.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<void> addExpense(
    String carId, {
    required ExpenseType type,
    required String userID,
    required double amount,
    required DateTime date,
  }) async* {
    Expense expense = Expense(
      userId: userID,
      type: type,
      amount: amount,
      date: date,
    );

    await carsCollection.doc(carId).collection('expenses').add(expense.toMap());
    yield null;
  }

  Stream<void> updateExpense(
    String carId,
    String expenseId,
    Expense updatedExpense,
  ) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .update(updatedExpense.toMap());
    setActiveExpense(updatedExpense);
    yield null;
  }

  Stream<void> deleteExpense(String carId, String expenseId) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
    yield null;
  }

  Stream<Expense?> getExpenseById(String carId, String expenseId) async* {
    final docSnapshot = await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .get();

    if (docSnapshot.exists) {
      yield Expense.fromMap(
          expenseId, docSnapshot.data() as Map<String, dynamic>);
    } else {
      yield null;
    }
  }

  void setActiveExpense(Expense expense) {
    _activeExpense = expense;
  }

  Expense? get activeExpense => _activeExpense;
}
