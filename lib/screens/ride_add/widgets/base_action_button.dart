import 'package:car_log/screens/ride_edit/utils/ride_form_constants.dart';
import 'package:flutter/material.dart';

class BaseActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonLabel;
  final Icon buttonIcon;
  final bool isDeleteButton;

  const BaseActionButton({
    Key? key,
    required this.onPressed,
    this.isDeleteButton = false,
    required this.buttonLabel,
    required this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: isDeleteButton ? RideFormConstants.DELETE_ICON : buttonIcon,
      label: Text(
        isDeleteButton ? RideFormConstants.DELETE_BUTTON_LABEL : buttonLabel,
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
