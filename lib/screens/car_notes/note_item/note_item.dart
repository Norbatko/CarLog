import 'package:car_log/screens/car_notes/note_item/message_bubble.dart';
import 'package:car_log/screens/car_notes/note_item/user_info_note_item.dart';
import 'package:car_log/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/note.dart';
import 'package:car_log/set_up_locator.dart';

const _HORIZONTAL_MARGIN = EdgeInsets.symmetric(horizontal: 12.0);

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({required this.note});

  @override
  Widget build(BuildContext context) {
    final currentUser = get<UserService>().currentUser;
    final isCurrentUser = note.userId == currentUser?.id;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: _HORIZONTAL_MARGIN,
        child: Column(
          crossAxisAlignment: isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            UserInfoNoteItem(note: note, isCurrentUser: isCurrentUser),
            MessageBubble(note: note, isCurrentUser: isCurrentUser),
          ],
        ),
      ),
    );
  }
}