import 'package:flutter/material.dart';
import 'package:car_log/screens/car_notes/note_list.dart';
import 'package:car_log/screens/car_notes/note_input_field.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/model/note.dart';

class CarNotesScreen extends StatelessWidget {
  final CarService _carService = get<CarService>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<Note?> _replyNoteNotifier = ValueNotifier<Note?>(null);
  final FocusNode _inputFocusNode = FocusNode();

  CarNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCar = _carService.getActiveCar();

    return Scaffold(
      appBar: ApplicationBar(
        title: 'Notes',
        userDetailRoute: Routes.userDetail,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!_inputFocusNode.hasFocus) {
            _inputFocusNode.requestFocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: NoteList(
                carId: activeCar.id,
                scrollController: _scrollController,
                onReply: (note) {
                  _replyNoteNotifier.value = note;
                  _inputFocusNode.requestFocus();
                },
              ),
            ),
            ValueListenableBuilder<Note?>(
              valueListenable: _replyNoteNotifier,
              builder: (context, replyNote, child) {
                return NoteInputField(
                  messageController: _messageController,
                  carId: activeCar.id,
                  scrollController: _scrollController,
                  replyNote: replyNote,
                  focusNode: _inputFocusNode,
                  onCancelReply: () {
                    _replyNoteNotifier.value = null;
                  },
                );
              },
            )

          ],
        ),
      ),
    );
  }
}
