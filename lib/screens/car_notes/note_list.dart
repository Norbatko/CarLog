import 'package:flutter/material.dart';
import 'package:car_log/screens/car_notes/note_item/note_item.dart';
import 'package:car_log/model/note.dart';
import 'package:car_log/services/note_service.dart';
import 'package:car_log/set_up_locator.dart';

class NoteList extends StatefulWidget {
  final String carId;
  final ScrollController scrollController;
  final ValueChanged<Note> onReply;

  const NoteList({
    required this.carId,
    required this.scrollController,
    required this.onReply,
    Key? key,
  }) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    final noteService = get<NoteService>();

    return StreamBuilder<List<Note>>(
      stream: noteService.getNotes(widget.carId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data!;

        // Scroll to the bottom after the frame is built (first load only)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isFirstLoad && widget.scrollController.hasClients) {
            widget.scrollController.jumpTo(
              widget.scrollController.position.maxScrollExtent,
            );
            _isFirstLoad = false;  // Disable after first load
          }
        });

        return ListView.builder(
          controller: widget.scrollController,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteItem(
              note: note,
              carId: widget.carId,
              onReply: widget.onReply,
            );
          },
        );
      },
    );
  }
}
