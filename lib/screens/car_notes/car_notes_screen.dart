import 'package:car_log/screens/car_notes/note_input_field.dart';
import 'package:car_log/screens/car_notes/note_list.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';

const _APPBAR_TITLE = 'Notes';

class CarNotesScreen extends StatelessWidget {
  final CarService _carService = get<CarService>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  CarNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCar = _carService.getActiveCar();

    return Scaffold(
      appBar: ApplicationBar(
        title: _APPBAR_TITLE,
        userDetailRoute: Routes.userDetail
      ),
      body: Column(
        children: [
          Expanded(
            child: NoteList(
              carId: activeCar.id,
              scrollController: _scrollController,
            ),
          ),
          NoteInputField(
            messageController: _messageController,
            carId: activeCar.id,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}
