import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:car_log/base/models/user.dart';
import 'package:car_log/features/car_expenses/widgets/expense_add_receipt.dart';
import 'package:car_log/features/car_expenses/widgets/expense_receipt_list.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/car_expenses/services/cloud_api.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/features/car_expenses/services/receipt_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:car_log/base/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_menu/pie_menu.dart';

const _EDGE_INSETS = 16.0;
const _boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

class CarExpenseDetailScreen extends StatefulWidget {
  const CarExpenseDetailScreen({super.key});

  @override
  State<CarExpenseDetailScreen> createState() => _CarExpenseDetailScreenState();
}

class _CarExpenseDetailScreenState extends State<CarExpenseDetailScreen> {
  final _receiptService = get<ReceiptService>();
  final _userService = get<UserService>();
  final _carService = get<CarService>();
  final _expenseService = get<ExpenseService>();
  late CloudApi _cloudApi;
  late Future<void> _initializeCloudApi;
  late final Expense _currentExpense;

  @override
  void initState() {
    super.initState();
    _initializeCloudApi = _initializeApi();
    _currentExpense = _expenseService.activeExpense!;
  }

  Future<void> _initializeApi() async {
    final json = await rootBundle.loadString('assets/api/credentials.json');
    _cloudApi = CloudApi(json);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeCloudApi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to initialize Cloud API'),
          );
        }

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
                  title: 'Expense Detail', userDetailRoute: Routes.userDetail),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(
                    _EDGE_INSETS, _EDGE_INSETS, _EDGE_INSETS, _EDGE_INSETS * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildExpenseDetailRow(
                        'Type: ', expenseTypeToString(_currentExpense.type)),
                    const SizedBox(height: 8),
                    _buildExpenseDetailRow('Amount:',
                        '\$${_currentExpense.amount.toInt() == _currentExpense.amount ? _currentExpense.amount.toInt().toString() : _currentExpense.amount.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildExpenseDetailRow('Created By:',
                        _userService.getUserData(_currentExpense.userId)),
                    const SizedBox(height: 8),
                    _buildExpenseDetailRow('Date:',
                        '${_currentExpense.date.toLocal()}'.split(' ')[0]),
                    const SizedBox(height: 16, child: Divider()),
                    const Text("Receipts", style: _boldTextStyle),
                    StreamCustomBuilder(
                        stream: _receiptService.getReceiptsByUserId(
                            _carService.activeCar.id,
                            _currentExpense.id,
                            _userService.currentUser!.id),
                        builder: (context, receipts) {
                          return receipts.isEmpty
                              ? Expanded(
                                  child: const Center(
                                    child: Text(
                                      'No receipts available',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  ),
                                )
                              : ExpenseReceiptList(
                                  receipts: receipts,
                                  cloudApi: _cloudApi,
                                );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _expenseService
                                  .deleteExpense(_carService.activeCar.id,
                                      _currentExpense.id)
                                  .listen((_) {});
                              _cloudApi.deleteFolder("${_currentExpense.id}/");
                            });
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              floatingActionButton: ExpenseAddReceipt(
                cloudApi: _cloudApi,
              )),
        );
      },
    );
  }

  Widget _buildExpenseDetailRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _boldTextStyle),
        value is Stream<User?>
            ? StreamBuilder<User?>(
                stream: value,
                builder: (_, snapshot) =>
                    Text(snapshot.data?.email ?? 'Unknown User'),
              )
            : Text(value),
      ],
    );
  }
}
