import 'package:car_log/features/car_notes/note_item/widget/edit_dialog.dart';
import 'package:car_log/features/car_notes/note_item/widget/note_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/note.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/features/car_notes/services/note_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:swipe_to/swipe_to.dart';

const _EDIT_TEXT = Text('Edit Note');
const _DELETE_TEXT = Text('Delete Note');
const _REPLY_TEXT = Text('Reply');
const _SUCCESS_STATUS = 'success';
const _NOTE_DELETED_SUCCESSFULLY = 'Note deleted successfully';
const _ICON_DELETE = Icon(Icons.delete);
const _ICON_EDIT = Icon(Icons.edit);
const _ICON_REPLY = Icon(Icons.reply);

class NoteItem extends StatelessWidget {
  final Note note;
  final String carId;
  final ValueChanged<Note>? onReply;

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
    final hasRightsToEditAndDelete = isCurrentUser || isAdmin;
    final noteService = get<NoteService>();

    return GestureDetector(
      onLongPress: () {
        _showOptions(context, noteService, hasRightsToEditAndDelete);
      },
      child: SwipeTo(
        onRightSwipe: !isCurrentUser
          ? (details) {
          if (onReply != null) onReply!(note);
          }
          : null,
        onLeftSwipe: isCurrentUser
          ? (details) {
          if (onReply != null) {onReply!(note);}
          }
          : null,
        child: NoteContentWidget(note:note ,isCurrentUser: isCurrentUser),
      ),
    );
  }

  void _showOptions(
      BuildContext context, NoteService noteService, bool hasRightsToEditAndDelete) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (hasRightsToEditAndDelete)
              ListTile(
                leading: _ICON_EDIT,
                title: _EDIT_TEXT,
                onTap: () {
                  Navigator.pop(context);
                  _editNote(context, noteService, carId, note);
                },
              ),
            ListTile(
              leading: _ICON_REPLY,
              title: _REPLY_TEXT,
              onTap: () {
                Navigator.pop(context);
                if (onReply != null) onReply!(note);
              },
            ),
            if (hasRightsToEditAndDelete)
              ListTile(
                leading: _ICON_DELETE,
                title: _DELETE_TEXT,
                onTap: () {
                  Navigator.pop(context);
                  _deleteNote(noteService, carId, note);
                },
              ),
          ],
        );
      },
    );
  }

  void _deleteNote(NoteService noteService, String carId, Note note) {
    noteService.deleteNote(carId, note.id).listen((status) {
      if (status == _SUCCESS_STATUS) {
        print(_NOTE_DELETED_SUCCESSFULLY);
      } else {
        print('Failed to delete note: $status');
      }
    });
  }

  void _editNote(BuildContext context, NoteService noteService, String carId, Note note) {
    TextEditingController controller = TextEditingController(text: note.content);
    showDialog(
      context: context,
      builder: (context) {
        return buildEditDialog(context, controller, noteService, carId, note);
      },
    );
  }
}
