import 'package:flutter/material.dart';
import 'package:car_log/model/user.dart';

class UserDetailsCard extends StatelessWidget {
  final User user;

  const UserDetailsCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Name', user.name),
        const SizedBox(height: 8),
        _buildDetailRow('Login', user.login),
        const SizedBox(height: 8),
        _buildDetailRow('Email', user.email),
        const SizedBox(height: 8),
        _buildDetailRow('Phone', user.phoneNumber),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 22, color: Colors.black),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
              text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
