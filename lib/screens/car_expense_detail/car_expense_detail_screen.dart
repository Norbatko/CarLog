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
import 'package:image_picker/image_picker.dart';
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

  String? selectedFileName;
  String? selectedFilePath;

  Future<void> pickFile() async {
    try {
      // Attempt to pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Allow any file type
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        setState(() {
          selectedFileName = file.name;
          selectedFilePath = file.path;
        });
      } else {
        // User canceled the picker
        setState(() {
          selectedFileName = null;
          selectedFilePath = null;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
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
                                return Container(
                                  child: ListTile(
                                    leading: Text(receipt.id),
                                    title: Text(receipt.userId),
                                    onTap: () {},
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
