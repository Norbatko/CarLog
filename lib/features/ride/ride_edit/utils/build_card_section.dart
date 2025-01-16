import 'package:flutter/material.dart';

class BuildCardSection extends StatelessWidget {
  const BuildCardSection({
    super.key,
    required this.context,
    required this.title,
    required this.children,
  });

  final BuildContext context;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
