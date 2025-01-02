import 'package:car_log/model/note.dart';
import 'package:car_log/services/note_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

const _PADDING = EdgeInsets.all(12.0);
const _BORDER_RADIUS = 12.0;
const _ANIMATION_DURATION = Duration(milliseconds: 300);
const _HINT_TEXT = 'Type a note...';

class NoteInputField extends StatelessWidget {
  final TextEditingController messageController;
  final String carId;
  final ScrollController scrollController;
  final NoteService _noteService = get<NoteService>();
  final UserService _userService = get<UserService>();

  NoteInputField({
    required this.messageController,
    required this.carId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _PADDING,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: _HINT_TEXT,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_BORDER_RADIUS),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              String message = messageController.text;
              final currentUser = _userService.currentUser;
              if (message.isNotEmpty && currentUser != null) {
                _noteService.addNote(
                  Note(
                    userId: currentUser.id,
                    content: message,
                    userName: currentUser.name,
                  ),
                  carId,
                );
                messageController.clear();
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: _ANIMATION_DURATION,
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
