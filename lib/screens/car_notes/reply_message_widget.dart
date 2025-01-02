import 'package:car_log/model/note.dart';
import 'package:flutter/material.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onCancelReply;

  const ReplyMessageWidget({
    required this.note,
    required this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: [
        Container(
          color: Colors.green,
          width: 4,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    ),
  );
}
