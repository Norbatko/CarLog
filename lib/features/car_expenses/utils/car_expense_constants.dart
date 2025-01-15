import 'package:flutter/material.dart';

// General Constants
const TITLE = 'Car Expenses';
const CARD_ELEVATION = 4.0;
const CARD_RADIUS = 16.0;
const SPACING_VERTICAL = 18.0;
const SPACING_HORIZONTAL = 20.0;
const SECTION_PADDING = 12.0;
const ICON_SIZE = 22.0;
const DATE_FORMAT = 'dd.MM.yy';

// Text Styles
const TEXT_STYLE = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

// Empty State Texts
const NO_EXPENSES_TEXT = Text(
  'No expenses found',
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
);
const ADD_EXPENSE_TEXT = Text(
  'Track your expenses to manage your costs.',
  style: TextStyle(
    fontSize: 16,
    color: Colors.black54,
  ),
);

// Icon and Layout Constants
const ICON_BOX_WIDTH = 28.0;
const SPACING_BETWEEN_ICON_TEXT = 8.0;
const LOTTIE_ANIMATION_PATH = 'assets/animations/nothing.json';

// Margins for Cards
const CARD_MARGIN = EdgeInsets.symmetric(
  horizontal: SPACING_HORIZONTAL,
  vertical: SPACING_VERTICAL / 3,
);

// Padding for Card Content
const CARD_PADDING = EdgeInsets.all(SPACING_VERTICAL);

// SizedBox Constants
const SIZED_BOX_HEIGHT_24 = SizedBox(height: 24);
const SIZED_BOX_HEIGHT_10 = SizedBox(height: 10);
