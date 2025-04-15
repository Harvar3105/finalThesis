import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:final_thesis_app/data/domain/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Id currentUserId;

  const MessageBubble({super.key, required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.senderId == currentUserId // замени на реальную проверку
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
            //TODO: Here needs to be circle avatar + first name + last name + account type
            Text(message.text),
            Text(message.createdAt.toString()) //TODO: To local dateTime then to string
          ]
        ),
      ),
    );
  }
}