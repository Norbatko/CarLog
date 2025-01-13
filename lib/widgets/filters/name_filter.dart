import 'package:flutter/material.dart';

class NameFilter extends StatefulWidget {
  final String hintText;
  final void Function(String)? onChanged;
  const NameFilter(
      {super.key, required this.onChanged, required this.hintText});

  @override
  State<NameFilter> createState() => _NameFilterState();
}

class _NameFilterState extends State<NameFilter> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: "Search",
            hintText: widget.hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                ))),
        onChanged: widget.onChanged,
      ),
    );
  }
}
