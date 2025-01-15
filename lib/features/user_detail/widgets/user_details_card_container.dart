import 'package:flutter/material.dart';
import 'package:car_log/base/models/user.dart';
import 'package:car_log/features/user_detail/widgets/user_details_card.dart';

class UserDetailsCardContainer extends StatelessWidget {
  final User user;

  const UserDetailsCardContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserDetailsCard(user: user),
      ),
    );
  }
}
