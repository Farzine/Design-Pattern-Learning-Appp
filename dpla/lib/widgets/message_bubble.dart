// import 'package:flutter/material.dart';
// import 'package:design_patterns_app/models/message.dart';
// import 'package:design_patterns_app/models/user.dart';

// class MessageBubble extends StatelessWidget {
//   final Message message;

//   const MessageBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isMe = message.senderId == 'currentUserId'; // Replace with actual current user ID
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blueAccent : Colors.grey[300],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           message.content,
//           style: TextStyle(color: isMe ? Colors.white : Colors.black87),
//         ),
//       ),
//     );
//   }
// }
