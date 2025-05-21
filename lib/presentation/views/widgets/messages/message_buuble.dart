import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:final_thesis_app/data/domain/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Id currentUserId;

  const MessageBubble({super.key, required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Align(
      alignment: message.senderId == currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children:[
            Text(message.text, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black)),
            Text(DateFormat('dd.MM.yy - HH:mm').format(message.createdAt.toLocal()),
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey))
          ]
        ),
      ),
    );
  }
}