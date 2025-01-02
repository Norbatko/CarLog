import 'package:car_log/model/note.dart';
import 'package:car_log/screens/car_notes/note_item/note_item.dart';
import 'package:car_log/services/note_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final String carId;
  final ScrollController scrollController;
  final NoteService _noteService = get<NoteService>();

  NoteList({required this.carId, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: _noteService.getNotes(carId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No notes found'));
        } else {
          List<Note> notes = snapshot.data!;
          return ListView.builder(
            controller: scrollController,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NoteItem(note: notes[index]);
            },
          );
        }
      },
    );
  }
}