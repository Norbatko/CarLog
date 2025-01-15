import 'package:flutter/material.dart';

class RideFormConstants {
  // Section Titles
  static const LOCATION_DETAILS_TITLE = 'Location Details';
  static const RIDE_DETAILS_TITLE = 'Ride Details';
  static const TIME_DETAILS_TITLE = 'Time';

  static const  START_LOCATION_LABEL = 'Start Location';
  static const  END_LOCATION_LABEL = 'End Location';
  static const  DISTANCE_LABEL = 'Distance (km)';
  static const  SAVE_BUTTON_LABEL = 'Save Ride';
  static const  DELETE_BUTTON_LABEL = 'Delete Ride';

  static const  LOCATION_UPDATED_MESSAGE = 'Location updated.';
  static const  INVALID_TIME_TITLE = 'Invalid Time';
  static const  INVALID_TIME_MESSAGE = 'Start time must be before finish time.';
  static const  RIDE_SAVED_MESSAGE = 'Ride saved successfully';
  static const  RIDE_DELETED_MESSAGE = 'Ride deleted successfully';

  static const  SECTION_VERTICAL_MARGIN = 12.0;
  static const  CARD_PADDING = 16.0;
  static const  FIELD_SPACING = 16.0;
  static const  BUTTON_VERTICAL_PADDING = 12.0;
  static const  BUTTON_HORIZONTAL_PADDING = 24.0;
  static const  BUTTON_BORDER_RADIUS = 12.0;

  static const  FIRST_YEAR = 2000;
  static const  LAST_YEAR = 2100;

  static const Color DELETE_BUTTON_COLOR = Colors.red;
  static const Color DELETE_BACKGROUND_COLOR = Color(0xFFFCE8E6);
  static const Color SAVE_BACKGROUND_COLOR = Color(0xFFEFF7EE);
  static const Icon DELETE_ICON = Icon(Icons.delete);
  static const Icon SAVE_ICON = Icon(Icons.save);

  static var STARTED_AT_LABEL = 'Started At';
  static var FINISHED_AT_LABEL = 'Finished At';
}
