import 'package:car_log/model/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');

  ExpenseModel();

  Stream<void> addExpense(String carId, Expense expense) {
    carsCollection.doc(carId).collection('expenses').add(expense.toMap());
    return Stream.value(null);
  }

  Stream<void> updateExpense(
      String carId, String expenseId, Expense updatedExpense) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .update(updatedExpense.toMap());
  }

  Stream<void> deleteExpense(String carId, String expenseId) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  Stream<List<Expense>> getExpenses(String carId) {
    return carsCollection
        .doc(carId)
        .collection('expenses')
        .snapshots()
        .map((querySnapshot) {
      List<Expense> expensesList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        expensesList.add(Expense.fromMap(doc.id, data));
      }
      return expensesList;
    });
  }

  Stream<void> saveExpense(String carId, Expense expense) async* {
    if (expense.id.isEmpty) {
      await carsCollection
          .doc(carId)
          .collection('expenses')
          .add(expense.toMap());
    } else {
      await carsCollection
          .doc(carId)
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toMap());
    }
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
}
