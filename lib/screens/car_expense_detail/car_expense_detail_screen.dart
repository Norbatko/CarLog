import 'dart:io';

import 'package:car_log/model/expense.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/cloud_api.dart';
import 'package:car_log/services/receipt_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/stream_custom_builder.dart';
import 'package:car_log/widgets/image_picker.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:pie_menu/pie_menu.dart';

const _EDGE_INSETS = 16.0;

class CarExpenseDetailScreen extends StatefulWidget {
  const CarExpenseDetailScreen({super.key});

  @override
  State<CarExpenseDetailScreen> createState() => _CarExpenseDetailScreenState();
}

class _CarExpenseDetailScreenState extends State<CarExpenseDetailScreen> {
  final _receiptService = get<ReceiptService>();
  final _userService = get<UserService>();
  final _carService = get<CarService>();
  late CloudApi _cloudApi;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/api/credentials.json').then((json) {
      _cloudApi = CloudApi(json);
    });
  }

  void _showImageDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentExpense =
        ModalRoute.of(context)?.settings.arguments as Expense;

    return PieCanvas(
      theme: const PieTheme(
        delayDuration: Duration.zero,
        tooltipTextStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Scaffold(
        appBar: ApplicationBar(
            title: 'Car Detail', userDetailRoute: Routes.userDetail),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
              _EDGE_INSETS, _EDGE_INSETS, _EDGE_INSETS, _EDGE_INSETS * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Created By:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  StreamBuilder<User?>(
                    stream: _userService.getUserData(_currentExpense.userId),
                    builder: (context, snapshot) {
                      return Text(snapshot.data?.name ?? 'Loading...');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$${_currentExpense.amount.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Date:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_currentExpense.date.toLocal()}'.split(' ')[0]),
                ],
              ),
              Text("Receipts"),
              StreamCustomBuilder(
                  stream: _receiptService.getReceiptsByUserId(
                      _carService.activeCar.id,
                      _currentExpense.id,
                      _userService.currentUser!.id),
                  builder: (context, receipts) {
                    return receipts.isEmpty
                        ? const Center(
                            child: Text(
                              'No receipts available',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: receipts.length,
                              itemBuilder: (context, index) {
                                final receipt = receipts[index];
                                return Slidable(
                                  key: ValueKey(receipt.id),
                                  child: Container(
                                    child: ListTile(
                                      leading: Text(receipt.id),
                                      title: Text(receipt.userId),
                                      onTap: () {},
                                    ),
                                  ),
                                  startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            var navigator =
                                                Navigator.of(context);
                                            var cloudFileName =
                                                "${_currentExpense.id}/${_currentExpense.userId}/${receipt.id}";
                                            Uint8List imageBytes =
                                                await _cloudApi
                                                    .download(cloudFileName);
                                            _showImageDialog(
                                                navigator.context, imageBytes);
                                          },
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          foregroundColor: Colors.white,
                                          icon: Icons.image,
                                          label: 'Preview',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) async {
                                            var cloudFileName =
                                                "${_currentExpense.id}/${_currentExpense.userId}/${receipt.id}";
                                            Uint8List imageBytes =
                                                await _cloudApi
                                                    .download(cloudFileName);

                                            String? mimeType = lookupMimeType(
                                                '',
                                                headerBytes: imageBytes);
                                            if (mimeType == null ||
                                                !mimeType
                                                    .startsWith('image/')) {
                                              print(
                                                  'Unable to determine file type or not an image.');
                                              return;
                                            }

                                            String fileExtension = {
                                                  'image/png': 'png',
                                                  'image/jpeg': 'jpg',
                                                  'image/gif': 'gif',
                                                  'image/bmp': 'bmp',
                                                }[mimeType] ??
                                                'img';

                                            String? directoryPath =
                                                await FilePicker.platform
                                                    .getDirectoryPath();
                                            if (directoryPath == null) {
                                              print(
                                                  'User canceled directory selection.');
                                              return;
                                            }

                                            String savePath =
                                                '$directoryPath/${cloudFileName.split('/').last}.$fileExtension';
                                            File file = File(savePath);
                                            await file.writeAsBytes(imageBytes);
                                          },
                                          backgroundColor:
                                              const Color(0xFF7BC043),
                                          foregroundColor: Colors.white,
                                          icon: Icons.save_alt,
                                          label: 'Download',
                                        ),
                                      ]),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible:
                                        DismissiblePane(onDismissed: () {
                                      // Action when slid all the way
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Receipt ${receipt.id} deleted')),
                                      );
                                      _receiptService
                                          .deleteReceipt(
                                              _carService.activeCar.id,
                                              _currentExpense.id,
                                              receipt.id)
                                          .listen((_) {});
                                      _cloudApi.delete(
                                          "${_currentExpense.id}/${_currentExpense.userId}/${receipt.id}");
                                    }),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Receipt ${receipt.id} deleted')),
                                          );
                                          _receiptService
                                              .deleteReceipt(
                                                  _carService.activeCar.id,
                                                  _currentExpense.id,
                                                  receipt.id)
                                              .listen((_) {});
                                          _cloudApi.delete(
                                              "${_currentExpense.id}/${_currentExpense.userId}/${receipt.id}");
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
                            ),
                          );
                  }),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: PieMenu(
                      actions: [
                        PieAction(
                          tooltip: const Text('Gallery'),
                          onSelect: () {
                            final imagePickerHandler = ImagePickerHandler(
                                _currentExpense,
                                _cloudApi,
                                ImageSource.gallery);
                            imagePickerHandler.pickImage(context);
                          },
                          child: const Icon(Icons.image),
                        ),
                        PieAction(
                          tooltip: const Text('Camera'),
                          onSelect: () {
                            final imagePickerHandler = ImagePickerHandler(
                                _currentExpense, _cloudApi, ImageSource.camera);
                            imagePickerHandler.pickImage(context);
                          },
                          child: const Icon(Icons.camera_alt),
                        ),
                      ],
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle edit action
                        },
                        icon: const Icon(Icons.note_add),
                        label: const Text('Add receipt'),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle edit action
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
