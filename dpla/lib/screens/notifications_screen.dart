// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/notification.dart';
// import 'package:design_patterns_app/providers/notification_provider.dart';
// import 'package:design_patterns_app/widgets/notification_tile.dart';

// class NotificationsScreen extends ConsumerWidget {
//   const NotificationsScreen({Key? key}) : super(key: key);

//   void _markAsRead(BuildContext context, WidgetRef ref, List<String> notificationIds) async {
//     await ref.read(notificationProvider.notifier).markNotificationsAsRead(notificationIds);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Notifications marked as read')),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final notificationsState = ref.watch(notificationProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.mark_email_read),
//             onPressed: () {
//               final unreadIds = notificationsState.notifications
//                   .where((n) => !n.isRead)
//                   .map((n) => n.id)
//                   .toList();
//               if (unreadIds.isNotEmpty) {
//                 _markAsRead(context, ref, unreadIds);
//               }
//             },
//           ),
//         ],
//       ),
//       body: notificationsState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : notificationsState.error != null
//               ? Center(child: Text(notificationsState.error!))
//               : notificationsState.notifications.isEmpty
//                   ? const Center(child: Text('No notifications.'))
//                   : ListView.builder(
//                       itemCount: notificationsState.notifications.length,
//                       itemBuilder: (context, index) {
//                         final notification = notificationsState.notifications[index];
//                         return NotificationTile(notification: notification);
//                       },
//                     ),
//     );
//   }
// }
