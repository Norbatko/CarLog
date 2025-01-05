import 'package:car_log/screens/ride_edit/utils/ride_form_constants.dart';
import 'package:flutter/material.dart';

class SaveRideButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveRideButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: const Text(RideFormConstants.SAVE_BUTTON_LABEL),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: RideFormConstants.BUTTON_VERTICAL_PADDING,
          horizontal: RideFormConstants.BUTTON_HORIZONTAL_PADDING,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            RideFormConstants.BUTTON_BORDER_RADIUS,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
