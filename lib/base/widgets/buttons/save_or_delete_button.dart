import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:flutter/material.dart';

class SaveOrDeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDeleteButton;
  final String saveText;
  final String deleteText;

  const SaveOrDeleteButton({
    Key? key,
    required this.onPressed,
    this.isDeleteButton = false,
    this.saveText = 'Save',
    this.deleteText = 'Delete',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: isDeleteButton
          ? RideFormConstants.DELETE_ICON
          : RideFormConstants.SAVE_ICON,
      label: Text(
        isDeleteButton ? deleteText : saveText,
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isDeleteButton
            ? RideFormConstants.DELETE_BUTTON_COLOR
            : Theme.of(context).primaryColor,
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
