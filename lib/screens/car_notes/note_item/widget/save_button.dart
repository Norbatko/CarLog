import 'package:flutter/material.dart';
import 'package:car_log/model/note.dart';
import 'package:car_log/services/note_service.dart';

const _SAVE_TEXT = Text('Save');

Widget buildSaveButton(
    BuildContext context,
    TextEditingController controller,
    NoteService noteService,
    String carId,
    Note note) {
  return TextButton(
    onPressed: () {
      _saveNote(context, controller.text, noteService, carId, note);
    },
    child: _SAVE_TEXT,
  );
}

void _saveNote(BuildContext context, String updatedContent, NoteService noteService,
    String carId, Note note) {
  noteService.updateNote(
    carId,
    note.id,
    note.copyWith(content: updatedContent),
  ).listen((status) {
    print('Status: $status');
  });
  Navigator.pop(context);
}
