import 'package:car_log/model/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');

  ReceiptModel();

  Stream<void> addReceipt(
      String carId, String expenseId, String receiptId, Receipt receipt) {
    carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .doc(receiptId)
        .set(receipt.toMap());
    return Stream.value(null);
  }

  Stream<void> updateReceipt(String carId, String expenseId, String receiptId,
      Receipt updatedReceipt) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .doc(receiptId)
        .update(updatedReceipt.toMap());
  }

  Stream<void> deleteReceipt(
      String carId, String expenseId, String receiptId) async* {
    await carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .doc(receiptId)
        .delete();
  }

  Stream<List<Receipt>> getReceipts(String carId, String expenseId) {
    return carsCollection
        .doc(carId)
        .collection('expenses')
        .doc(expenseId)
        .collection('receipts')
        .snapshots()
        .map((querySnapshot) {
      List<Receipt> receiptsList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        receiptsList.add(Receipt.fromMap(doc.id, data));
      }
      return receiptsList;
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
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Receipt(
                id: doc.id,
                userId: data['userId'],
                date: (data['date'] as Timestamp).toDate(),
              );
            }).toList());
  }
}
