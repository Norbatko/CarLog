import 'package:car_log/features/car_notes/widgets/reply_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:car_log/features/car_notes/models/note.dart';
import 'package:car_log/features/car_notes/services/note_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';

// Constants for Padding, Border Radius, and Spacing
const _BORDER_RADIUS = 12.0;
const _PADDING_12 = EdgeInsets.all(12.0);
const _PADDING_8 = EdgeInsets.all(8.0);
const _TOP_BORDER = BorderSide(color: Colors.black54, width: 0.8);
const _ICON_SIZE = 18.0;
const _HINT_TEXT = 'Type a note...';
const _ICON_SEND = Icon(Icons.send);
const _ICON_CLOSE = Icon(Icons.close, size: _ICON_SIZE);
const _DURATION_300_MS = Duration(milliseconds: 300);

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
    Key? key,
  }) : super(key: key);

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

    FocusScope.of(context).unfocus();

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: _DURATION_300_MS,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (replyNote != null) _buildReplyContainer(),
        Padding(
          padding: _PADDING_12,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  focusNode: focusNode,
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
                icon: _ICON_SEND,
                onPressed: () => _sendMessage(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyContainer() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: _TOP_BORDER),
      ),
      padding: _PADDING_8,
      child: Row(
        children: [
          Expanded(
            child: ReplyMessageWidget(note: replyNote!, onCancelReply: onCancelReply),
          ),
          GestureDetector(
            onTap: onCancelReply,
            child: _ICON_CLOSE,
          ),
        ],
      ),
    );
  }
}
