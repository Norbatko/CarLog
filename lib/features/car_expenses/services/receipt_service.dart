import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/features/car_expenses/models/receipt.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ReceiptService {
  final UserService _userService;

  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');

  Receipt? _activeReceipt;

  ReceiptService({required UserService userService})
      : _userService = userService;

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
    return _userService.getUserData(userId).switchMap((user) {
      if (user == null) {
        // Handle the case where the user does not exist
        return Stream.value([]);
      }

      if (user.isAdmin) {
        // Admin: Return all receipts
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
      } else {
        // Regular user: Return only their receipts
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
    });
  }

  Stream<void> addReceipt(
    String carId,
    String expenseId,
    String receiptId, {
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
        .doc(receiptId)
        .set(receipt.toMap());
    yield null;
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
    yield null;
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
    yield null;
  }

  void setActiveReceipt(Receipt receipt) {
    _activeReceipt = receipt;
  }

  Receipt? get activeReceipt => _activeReceipt;
}
