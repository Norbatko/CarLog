import 'package:flutter/material.dart';
import 'package:car_log/features/car_notes/models/note.dart';
import 'package:car_log/features/car_notes/note_item/message_bubble.dart';
import 'package:car_log/features/car_notes/note_item/user_info_note_item.dart';
import 'package:car_log/features/car_notes/widgets/reply_message_widget.dart';

const _HORIZONTAL_MARGIN = EdgeInsets.symmetric(horizontal: 12.0);
const _BORDER_RADIUS = 12.0;
const _EDGE_INSETS_12 = EdgeInsets.all(12.0);
const _SIZED_BOX_4 = SizedBox(height: 4);

class NoteContentWidget extends StatelessWidget {
  final Note note;
  final bool isCurrentUser;

  const NoteContentWidget({
    Key? key,
    required this.note,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: _HORIZONTAL_MARGIN,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_BORDER_RADIUS),
        ),
        padding: _EDGE_INSETS_12,
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildReplyWidget(),
            _buildUserInfo(isCurrentUser),
            _SIZED_BOX_4,
            _buildMessageBubble(isCurrentUser),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyWidget() {
    if (note.replyNoteContent == null) return const SizedBox.shrink();

    return Column(
      children: [
        _SIZED_BOX_4,
        ReplyMessageWidget(
          note: Note(
            userId: note.userId,
            content: note.replyNoteContent!,
            userName: note.userName,
          ),
          onCancelReply: () {},
        ),
        _SIZED_BOX_4,
      ],
    );
  }

  Widget _buildUserInfo(bool isCurrentUser) {
    return UserInfoNoteItem(
      note: note,
      isCurrentUser: isCurrentUser,
    );
  }

  Widget _buildMessageBubble(bool isCurrentUser) {
    return MessageBubble(
      note: note,
      isCurrentUser: isCurrentUser,
    );
  }
}
