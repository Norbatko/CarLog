import 'package:car_log/features/car_expenses/models/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptService {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  Receipt? _activeReceipt;

  ReceiptService._private();

  static final ReceiptService _instance = ReceiptService._private();

  factory ReceiptService() => _instance;

  Stream<List<Receipt>> getReceipts(String carId, String expenseId) {
    return carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Receipt.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<List<Receipt>> getReceiptsByUserId(
      String carId, String expenseId, String userId) {
    return carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Receipt.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<void> addReceipt(
      String carId,
      String expenseId,
      String receiptId,{
        required String userID,
        required DateTime date,
      }) async* {
    Receipt receipt = Receipt(
      userId: userID,
      date: date,
    );

    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .add(receipt.toMap());
    yield null;
  }

  Stream<void> updateReceipt(
      String carId, String expenseId, String receiptId, Receipt updatedReceipt) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .doc(receiptId)
        .update(updatedReceipt.toMap());
    yield null;
  }

  Stream<void> deleteReceipt(String carId, String expenseId, String receiptId) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .doc(receiptId)
        .delete();
    yield null;
  }

  void setActiveReceipt(Receipt receipt) {
    _activeReceipt = receipt;
  }

  Receipt? get activeReceipt => _activeReceipt;
}
