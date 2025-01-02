import 'package:car_log/model/note.dart';
import 'package:car_log/screens/car_notes/note_item/note_item.dart';
import 'package:car_log/services/note_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final String carId;
  final ScrollController scrollController;
  final ValueChanged<Note> onReply;

  const NoteList({
    required this.carId,
    required this.scrollController,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final noteService = get<NoteService>();

    return StreamBuilder<List<Note>>(
      stream: noteService.getNotes(carId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data!;
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteItem(
              note: note,
              carId: carId,
              onReply: onReply,
            );
          },
        );
      },
    );
  }
}
