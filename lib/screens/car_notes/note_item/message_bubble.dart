import 'package:car_log/model/note.dart';
import 'package:flutter/material.dart';

const _VERTICAL_MARGIN = EdgeInsets.only(top: 4.0);
const _BUBBLE_PADDING = EdgeInsets.all(8.0);
const _BORDER_RADIUS = 8.0;
const _MESSAGE_FONT_SIZE = 16.0;

class MessageBubble extends StatelessWidget {
  final Note note;
  final bool isCurrentUser;

  const MessageBubble({required this.note, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: _VERTICAL_MARGIN,
        padding: _BUBBLE_PADDING,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.66,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(_BORDER_RADIUS),
        ),
        child: Text(
          note.content,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: isCurrentUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSecondary,
            fontSize: _MESSAGE_FONT_SIZE,
          ),
        ),
      ),
    );
  }
}