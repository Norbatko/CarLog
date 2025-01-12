import 'package:flutter/material.dart';

class AdminFilter extends StatefulWidget {
  final void Function(bool) onChanged;
  const AdminFilter({super.key, required this.onChanged});

  @override
  State<AdminFilter> createState() => _AdminFilterState();
}

class _AdminFilterState extends State<AdminFilter> {
  bool _isAdminFilterOn = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Admins Only'),
          Switch(
            value: _isAdminFilterOn,
            onChanged: (value) {
              // Update the internal state
              setState(() {
                _isAdminFilterOn = value;
              });
              // Also update the parent state via the callback
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
