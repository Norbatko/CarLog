import 'package:car_log/screens/car_notes/reply_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/note.dart';
import 'package:car_log/services/note_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';

const _BORDER_RADIUS = 12.0;

class NoteInputField extends StatelessWidget {
  final TextEditingController messageController;
  final String carId;
  final ScrollController scrollController;
  final Note? replyNote;
  final FocusNode focusNode;  // Accept FocusNode
  final VoidCallback onCancelReply;

  const NoteInputField({
    required this.messageController,
    required this.carId,
    required this.scrollController,
    this.replyNote,
    required this.focusNode,
    required this.onCancelReply,
  });

  void _sendMessage(BuildContext context) {
    final currentUser = get<UserService>().currentUser;
    if (messageController.text.isEmpty || currentUser == null) return;

    final newNote = Note(
      userId: currentUser.id,
      content: messageController.text,
      userName: currentUser.name,
      replyNoteId: replyNote?.id,
      replyNoteContent: replyNote?.content,
    );

    get<NoteService>().addNote(newNote, carId);
    messageController.clear();
    onCancelReply();

    // Unfocus the text field and hide the keyboard
    FocusScope.of(context).unfocus();

    // Scroll to the bottom smoothly
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (replyNote != null)
          Container(
            decoration: BoxDecoration(
              border: const Border(
                top: BorderSide(
                  color: Colors.black54,  // Thin black line
                  width: 0.8,  // Thickness of the line
                ),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ReplyMessageWidget(note: replyNote!, onCancelReply: onCancelReply),
                ),
                GestureDetector(
                  onTap: onCancelReply,
                  child: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  focusNode: focusNode,  // Use passed focus node
                  decoration: InputDecoration(
                    hintText: 'Type a note...',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_BORDER_RADIUS),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _sendMessage(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
