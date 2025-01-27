import 'dart:io';
import 'dart:typed_data';

import 'package:car_log/base/models/user.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/base/widgets/top_snack_bar.dart';
import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/features/car_expenses/models/receipt.dart';
import 'package:car_log/features/car_expenses/services/cloud_api.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/features/car_expenses/services/receipt_service.dart';
import 'package:car_log/features/car_expenses/widgets/expense_image_info_dialog.dart';
import 'package:car_log/features/car_expenses/widgets/expense_image_preview_dialog.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mime/mime.dart';

class ExpenseReceiptList extends StatelessWidget {
  final List<Receipt> receipts;
  final CloudApi cloudApi;

  const ExpenseReceiptList(
      {super.key, required this.receipts, required this.cloudApi});

  @override
  Widget build(BuildContext context) {
    final userService = get<UserService>();
    final expenseService = get<ExpenseService>();
    final carService = get<CarService>();
    final receiptService = get<ReceiptService>();
    final currentExpense = expenseService.activeExpense!;

    return ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final receipt = receipts[index];
        return Slidable(
          key: ValueKey(receipt.id),
          child: ListTile(
            leading: const Icon(Icons.image),
            title: Text("Receipt: ${receipt.id}"),
            trailing: StreamBuilder<User?>(
              stream: userService.getUserData(receipt.userId),
              builder: (context, snapshot) {
                return TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/user/detail',
                      arguments: receipt.userId,
                    );
                  },
                  child: Text(snapshot.data?.login ??
                      'Unknown User'), // Show the user name or a fallback
                );
              },
            ),
            onTap: () async {
              var navigator = Navigator.of(context);
              var cloudFileName =
                  "${currentExpense.id}/${receipt.userId}/${receipt.id}";
              Uint8List imageBytes = await cloudApi.download(cloudFileName);
              _showImageDialog(navigator.context, imageBytes);
            },
          ),
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              onPressed: (context) =>
                  _downloadFile(currentExpense, receipt, context),
              backgroundColor: const Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.save_alt,
              label: 'Download',
            ),
            SlidableAction(
              onPressed: (context) => _showInfoImageDialog(context, receipt),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              icon: Icons.info,
              label: 'Info',
            ),
          ]),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {
              TopSnackBar.show(context, 'Receipt ${receipt.id} deleted');
              receiptService
                  .deleteReceipt(
                      carService.activeCar.id, currentExpense.id, receipt.id)
                  .listen((_) {});
              cloudApi.deleteFile(
                  "${currentExpense.id}/${receipt.userId}/${receipt.id}");
            }),
            children: [
              SlidableAction(
                onPressed: (context) {
                  TopSnackBar.show(context, 'Receipt ${receipt.id} deleted');
                  receiptService
                      .deleteReceipt(carService.activeCar.id, currentExpense.id,
                          receipt.id)
                      .listen((_) {});
                  cloudApi.deleteFile(
                      "${currentExpense.id}/${receipt.userId}/${receipt.id}");
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExpenseImagePreviewDialog(imageBytes: imageBytes);
      },
    );
  }

  void _showInfoImageDialog(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExpenseImageInfoDialog(
          receipt: receipt,
        );
      },
    );
  }

  void _downloadFile(
      Expense expense, Receipt receipt, BuildContext context) async {
    var cloudFileName = "${expense.id}/${receipt.userId}/${receipt.id}";
    Uint8List imageBytes = await cloudApi.download(cloudFileName);

    String? mimeType = lookupMimeType('', headerBytes: imageBytes);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      print('Unable to determine file type or not an image.');
      return;
    }

    String fileExtension = {
          'image/png': 'png',
          'image/jpeg': 'jpg',
          'image/gif': 'gif',
          'image/bmp': 'bmp',
        }[mimeType] ??
        'img';

    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      print('User canceled directory selection.');
      return;
    }

    String savePath =
        '$directoryPath/${cloudFileName.split('/').last}.$fileExtension';
    File file = File(savePath);
    await file.writeAsBytes(imageBytes);
  }
}
