import 'package:flutter/material.dart';
import 'package:car_log/features/car_notes/models/note.dart';
import 'cancel_button.dart';
import 'save_button.dart';
import 'package:car_log/features/car_notes/services/note_service.dart';

const _EDIT_TEXT = Text('Edit Note');
const _EDIT_HINT_TEXT = 'Edit your message';

Widget buildEditDialog(BuildContext context, TextEditingController controller,
    NoteService noteService, String carId, Note note) {
  return AlertDialog(
    title: _EDIT_TEXT,
    content: TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: _EDIT_HINT_TEXT),
    ),
    actions: [
      buildCancelButton(context),
      buildSaveButton(context, controller, noteService, carId, note),
    ],
  );
}
