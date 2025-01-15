import 'dart:io';
import 'dart:typed_data';

import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/car_expenses/services/cloud_api.dart';
import 'package:car_log/features/car_expenses/services/receipt_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ImagePickerHandler {
  final Expense expense;
  final CloudApi api;
  final ImageSource imageSource;
  late File _image;
  Uint8List? _imageBytes;
  late String _imageName;

  ImagePickerHandler(this.expense, this.api, this.imageSource);

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _imageBytes = await _image.readAsBytes();
      _imageName = "${expense.id}/${expense.userId}/${_image.path.hashCode}";

      _showProgressDialog(context);

      try {
        await _uploadImage();
        Navigator.of(context).pop(); // Close progress dialog
        _showSnackBar(context, 'Image uploaded successfully!');
      } catch (e) {
        _showSnackBar(context, 'Upload failed: $e');
      }
    } else {
      _showSnackBar(context, 'No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes != null) {
      await api.save(_imageName, _imageBytes!);
    }
    final _receiptService = get<ReceiptService>();
    final _carService = get<CarService>();
    _receiptService
        .addReceipt(_carService.activeCar.id, expense.id,
            _image.path.hashCode.toString(),
            userID: expense.userId, date: DateTime.now())
        .listen((_) {});
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Lottie.asset(
            'assets/animations/image_upload.json',
            width: 200,
            height: 200,
            repeat: true,
          ),
        );
      },
    );
  }
}
