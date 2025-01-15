import 'package:flutter/material.dart';

// General Titles
const CAR_HISTORY_TITLE = 'Car History';

// Card UI
const CARD_ELEVATION = 4.0;
const CARD_RADIUS = 16.0;
const SPACING_VERTICAL = 18.0;
const SPACING_HORIZONTAL = 20.0;
const SECTION_PADDING = 12.0;
const ICON_SIZE = 22.0;

// Text Styles
const TEXT_STYLE = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
const NO_RIDE_HISTORY_TEXT = Text(
  'No ride history found',
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
);
const ADD_FIRST_RIDE_TEXT = Text(
  'Add your first ride to track your journeys.',
  style: TextStyle(
    fontSize: 16,
    color: Colors.black54,
  ),
);

// Spacing and Padding
const RIDE_CARD_EDGE_SYMMETRIC = EdgeInsets.symmetric(
  horizontal: SPACING_HORIZONTAL,
  vertical: SPACING_VERTICAL / 3,
);
const SIZED_BOX_WIDTH_12 = SizedBox(width: 12.0);
const SIZED_BOX_HEIGHT_24 = SizedBox(height: 24);
const SIZED_BOX_HEIGHT_20 = SizedBox(width: 20);
const SIZED_BOX_HEIGHT_10 = SizedBox(height: 10);

