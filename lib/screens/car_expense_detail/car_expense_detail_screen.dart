import 'package:car_log/model/expense.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/stream_custom_builder.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

const _EDGE_INSETS = 16.0;

class CarExpenseDetailScreen extends StatefulWidget {
  const CarExpenseDetailScreen({super.key});

  @override
  State<CarExpenseDetailScreen> createState() => _CarExpenseDetailScreenState();
}

class _CarExpenseDetailScreenState extends State<CarExpenseDetailScreen> {
  final notes = '';
  final _userService = get<UserService>();

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

        debugPrint('File Name: ${file.name}');
        debugPrint('File Path: ${file.path}');
      } else {
        // User canceled the picker
        setState(() {
          selectedFileName = null;
          selectedFilePath = null;
        });
        debugPrint('File picking canceled.');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentExpense =
        ModalRoute.of(context)?.settings.arguments as Expense;

    return Scaffold(
      appBar: ApplicationBar(
          title: 'Car Detail', userDetailRoute: Routes.userDetail),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            _EDGE_INSETS, _EDGE_INSETS, _EDGE_INSETS, _EDGE_INSETS * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Row(
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
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(notes),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle edit action
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: pickFile,
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
    );
  }
}
