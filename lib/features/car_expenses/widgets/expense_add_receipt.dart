import 'package:car_log/base/widgets/image_picker.dart';
import 'package:car_log/features/car_expenses/services/cloud_api.dart';
import 'package:car_log/features/car_expenses/services/expense_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_menu/pie_menu.dart';

class ExpenseAddReceipt extends StatelessWidget {
  final CloudApi cloudApi;

  const ExpenseAddReceipt({super.key, required this.cloudApi});

  @override
  Widget build(BuildContext context) {
    final expenseService = get<ExpenseService>();
    return PieMenu(
      actions: [
        PieAction(
          tooltip: const Text('Gallery'),
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconColor: Theme.of(context).colorScheme.onSecondary),
          buttonThemeHovered: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              iconColor: Theme.of(context).colorScheme.primary,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSecondary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary, // Border color
                  width: 4, // Border width
                ),
              )),
          onSelect: () {
            final imagePickerHandler = ImagePickerHandler(
                expenseService.activeExpense!, cloudApi, ImageSource.gallery);
            imagePickerHandler.pickImage(context);
          },
          child: const Icon(Icons.image),
        ),
        PieAction(
          tooltip: const Text('Camera'),
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconColor: Theme.of(context).colorScheme.onSecondary),
          buttonThemeHovered: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              iconColor: Theme.of(context).colorScheme.primary,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSecondary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary, // Border color
                  width: 4, // Border width
                ),
              )),
          onSelect: () {
            final imagePickerHandler = ImagePickerHandler(
                expenseService.activeExpense!, cloudApi, ImageSource.camera);
            imagePickerHandler.pickImage(context);
          },
          child: const Icon(Icons.camera_alt),
        ),
      ],
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.note_add,
            color: Theme.of(context).colorScheme.onSecondary),
        onPressed: () {},
        heroTag: "addReceiptFAB",
      ),
    );
  }
}
