import 'package:flutter/material.dart';

const _SECTION_TITLE_FONT_SIZE = 24.0;

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: _SECTION_TITLE_FONT_SIZE, fontWeight: FontWeight.bold),
    );
  }
}
