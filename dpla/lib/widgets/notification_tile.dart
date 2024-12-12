// import 'package:flutter/material.dart';
// import 'package:design_patterns_app/models/notification.dart';

// class NotificationTile extends StatelessWidget {
//   final AppNotification notification;

//   const NotificationTile({Key? key, required this.notification}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;
//     Color iconColor;

//     switch (notification.type) {
//       case 'new_follower':
//         icon = Icons.person_add;
//         iconColor = Colors.green;
//         break;
//       case 'comment':
//         icon = Icons.comment;
//         iconColor = Colors.blue;
//         break;
//       case 'like':
//         icon = Icons.thumb_up;
//         iconColor = Colors.pink;
//         break;
//       case 'message':
//         icon = Icons.message;
//         iconColor = Colors.teal;
//         break;
//       case 'call_request':
//         icon = Icons.call;
//         iconColor = Colors.orange;
//         break;
//       case 'milestone':
//         icon = Icons.flag;
//         iconColor = Colors.purple;
//         break;
//       case 'test_completion':
//         icon = Icons.check_circle;
//         iconColor = Colors.lightBlue;
//         break;
//       default:
//         icon = Icons.notifications;
//         iconColor = Colors.grey;
//     }

//     return ListTile(
//       leading: Icon(icon, color: iconColor),
//       title: Text(_getNotificationText(notification)),
//       trailing: notification.isRead ? null : const Icon(Icons.circle, color: Colors.red, size: 10),
//       onTap: () {
//         // Implement navigation based on notification type
//       },
//     );
//   }

//   String _getNotificationText(AppNotification notification) {
//     switch (notification.type) {
//       case 'new_follower':
//         return 'You have a new follower.';
//       case 'comment':
//         return 'Someone commented on your post.';
//       case 'like':
//         return 'Someone liked your post.';
//       case 'message':
//         return 'You have a new message.';
//       case 'call_request':
//         return 'You have a new call request.';
//       case 'milestone':
//         return 'Congratulations on reaching a milestone!';
//       case 'test_completion':
//         return 'You have completed a test.';
//       default:
//         return 'You have a new notification.';
//     }
//   }
// }
