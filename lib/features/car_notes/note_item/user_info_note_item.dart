import 'package:car_log/features/car_notes/models/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _USERNAME_FONT_SIZE = 14.0;
const _TIMESTAMP_FONT_SIZE = 12.0;
const _SPACING_WIDTH = 6.0;
const _DATE_FORMAT = 'dd-MM-yyyy HH:mm';

class UserInfoNoteItem extends StatelessWidget {
  final Note note;
  final bool isCurrentUser;

  const UserInfoNoteItem({required this.note, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isCurrentUser)
          Text(
            note.userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _USERNAME_FONT_SIZE,
            ),
          ),
        if (!isCurrentUser) SizedBox(width: _SPACING_WIDTH),
        Text(
          DateFormat(_DATE_FORMAT).format(note.createdAt),
          style: TextStyle(
            fontSize: _TIMESTAMP_FONT_SIZE,
            color: Colors.black54,
          ),
        ),
        if (isCurrentUser) SizedBox(width: _SPACING_WIDTH),
      ],
    );
  }
}
