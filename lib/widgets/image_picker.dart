import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:car_log/model/expense.dart';
import 'package:car_log/services/cloud_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Expense expense;
  const ImagePickerWidget({super.key, required this.expense});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late File _image;
  Uint8List? _imageBytes;
  late String _imageName;
  final picker = ImagePicker();
  late CloudApi api;
  bool isUploaded = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/api/credentials.json').then((json) {
      api = CloudApi(json);
    });
  }

  void _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageBytes = _image.readAsBytesSync();
        _imageName = widget.expense.id +
            "/" +
            widget.expense.userId +
            "/" +
            _image.path.hashCode.toString();
        isUploaded = false;
      } else {
        print('No image selected.');
      }
      _saveImage();
    });
  }

  void _saveImage() async {
    setState(() {
      loading = true;
    });
    // Upload to Google cloud
    final response = await api.save(_imageName, _imageBytes!);
    setState(() {
      loading = false;
      isUploaded = true;
    });
  }

  void _getImageFromCloud() async {
    setState(() {
      loading = true;
    });
    print("Images bytes before: " + String.fromCharCodes(_imageBytes!));
    final xx = widget.expense.id;
    final zz = widget.expense.userId;
    _imageBytes = await api.download(xx + zz + _imageName);
    print("Images bytes after: " + String.fromCharCodes(_imageBytes!));

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loading)
          const CircularProgressIndicator()
        else if (isUploaded || _imageBytes != null)
          Image.memory(_imageBytes!, height: 100, width: 100, fit: BoxFit.cover)
        else
          FloatingActionButton(
            onPressed: _getImage,
            child: const Icon(Icons.add_a_photo),
          ),
        if (isUploaded)
          ElevatedButton(
            onPressed: _getImageFromCloud,
            child: const Text('Get Image from Cloud'),
          ),
      ],
    );
  }
}
