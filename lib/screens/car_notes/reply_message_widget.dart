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
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],  // Light grey background
              borderRadius: BorderRadius.circular(12),  // Rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),

      ],
    ),
  );
}
