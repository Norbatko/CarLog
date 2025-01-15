import 'package:flutter/material.dart';

const _CANCEL_TEXT = Text('Cancel');

Widget buildCancelButton(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.pop(context),
    child: _CANCEL_TEXT,
  );
}
