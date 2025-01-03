import 'dart:io';
import 'dart:typed_data';

import 'package:car_log/model/expense.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/cloud_api.dart';
import 'package:car_log/services/receipt_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

      // Upload to the cloud
      await uploadImage();
      showUploadedSnackBar(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  Future<void> uploadImage() async {
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

  void showUploadedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image uploaded successfully!')),
    );
  }
}
