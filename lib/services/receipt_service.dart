import 'package:car_log/model/expense.dart';
import 'package:car_log/model/receipt.dart';
import 'package:car_log/model/receipt_model.dart';

class ReceiptService {
  final ReceiptModel receiptModel;
  Receipt? _activeReceipt;

  ReceiptService._private(this.receiptModel);

  static final ReceiptService _instance =
      ReceiptService._private(ReceiptModel());

  factory ReceiptService() {
    return _instance;
  }

  Stream<List<Receipt>> getReceipts(String carId, String expenseId) =>
      receiptModel.getReceipts(carId, expenseId);

  Stream<List<Receipt>> getReceiptsByUserId(
          String carId, String expenseId, String userId) =>
      receiptModel.getReceiptsByUserId(carId, expenseId, userId);

  Receipt? get activeReceipt => _activeReceipt;

  Stream<void> addReceipt(
    String carId,
    String expenseId,
    String receiptId, {
    required ExpenseType type,
    required String userID,
    required DateTime date,
  }) async* {
    Receipt receipt = Receipt(
      id: '',
      userId: userID,
      date: date,
    );

    yield* receiptModel.addReceipt(carId, expenseId, receiptId, receipt);
  }

  Stream<void> deleteReceipt(
      String carId, String expenseId, String receiptId) async* {
    yield* receiptModel.deleteReceipt(carId, expenseId, receiptId);
  }

  Stream<void> updateReceipt(String carId, String expenseId, String receiptId,
      Receipt receipt) async* {
    yield* receiptModel.updateReceipt(carId, expenseId, receiptId, receipt);
  }

  void setActiveReceipt(Receipt receipt) {
    _activeReceipt = receipt;
  }
}
