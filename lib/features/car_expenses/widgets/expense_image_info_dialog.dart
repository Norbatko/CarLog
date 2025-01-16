import 'package:car_log/base/models/user.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/features/car_expenses/models/receipt.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class ExpenseImageInfoDialog extends StatelessWidget {
  final Receipt receipt;

  const ExpenseImageInfoDialog({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    UserService userService = get<UserService>();
    return AlertDialog(
      title: Text(
        "Image Details",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      ),
      content: StreamBuilder<User?>(
          stream: userService.getUserData(receipt.userId),
          builder: (context, snapshot) {
            var user = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            decoration: TextDecoration.underline)),
                    SizedBox(width: 5),
                    const Icon(Icons.image),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ID:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(receipt.id),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Creation date:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${receipt.date.toLocal()}'.split(' ')[0]),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          decoration: TextDecoration.underline,
                        )),
                    SizedBox(width: 5),
                    const Icon(Icons.person),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Name:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(user?.name ?? 'Unknown'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Login:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(user?.login ?? 'Unknown'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Email:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(user?.email ?? 'Unknown'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Role:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(user?.isAdmin == true ? 'Admin' : 'User'),
                  ],
                ),
              ],
            );
          }),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("Return"))
      ],
    );
  }
}
