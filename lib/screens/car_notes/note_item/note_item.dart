import 'package:car_log/screens/car_notes/note_item/message_bubble.dart';
import 'package:car_log/screens/car_notes/note_item/user_info_note_item.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/note.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/screens/car_notes/reply_message_widget.dart';

const _HORIZONTAL_MARGIN = EdgeInsets.symmetric(horizontal: 12.0);

class NoteItem extends StatelessWidget {
  final Note note;
  final String carId;
  final ValueChanged<Note>? onReply;  // Pass callback to handle replies

  const NoteItem({
    required this.note,
    required this.carId,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = get<UserService>().currentUser;
    final isCurrentUser = note.userId == currentUser?.id;
    final isAdmin = currentUser?.isAdmin ?? false;
    final noteService = get<NoteService>();

    return GestureDetector(
      onLongPress: () {
          _showOptions(context, isCurrentUser, noteService, isAdmin);
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          onReply?.call(note);  // Trigger reply action on swipe
        }
      },
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: _HORIZONTAL_MARGIN,
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (note.replyNoteContent != null)
                SizedBox( height: 8),
              if (note.replyNoteContent != null)
                ReplyMessageWidget(
                  note: Note(
                    userId: note.userId,
                    content: note.replyNoteContent!,
                    userName: note.userName,
                  ),
                  onCancelReply: () {},
                ),
              UserInfoNoteItem(note: note, isCurrentUser: isCurrentUser),
              MessageBubble(note: note, isCurrentUser: isCurrentUser),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, bool isCurrentUser, NoteService noteService, bool isAdmin) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (isCurrentUser || isAdmin)
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _editNote(context, noteService);
                },
              ),
            ListTile(
              leading: Icon(Icons.reply),
              title: Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                onReply?.call(note);  // Trigger reply callback
              },
            ),
            if (isCurrentUser || isAdmin)
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  noteService.deleteNote(carId, note.id).listen((status) {
                    if (status == 'success') {
                      print('Note deleted successfully');
                    } else {
                      print('Failed to delete note: $status');
                    }
                  });
                },
              ),
          ],
        );
      },
    );
  }

  void _editNote(BuildContext context, NoteService noteService) {
    TextEditingController controller = TextEditingController(text: note.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Edit your message'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                noteService.updateNote(
                  carId,
                  note.id,
                  note.copyWith(content: controller.text),
                ).listen((status) {
                  print('Status: $status');
                                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
