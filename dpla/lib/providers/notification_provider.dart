// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/notification.dart';
// import 'package:design_patterns_app/repositories/notification_repository.dart';
// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/core/exceptions.dart';

// // Define the state for notifications
// class NotificationState {
//   final List<AppNotification> notifications;
//   final bool isLoading;
//   final bool isMarking;
//   final String? error;

//   NotificationState({
//     this.notifications = const [],
//     this.isLoading = false,
//     this.isMarking = false,
//     this.error,
//   });

//   NotificationState copyWith({
//     List<AppNotification>? notifications,
//     bool? isLoading,
//     bool? isMarking,
//     String? error,
//   }) {
//     return NotificationState(
//       notifications: notifications ?? this.notifications,
//       isLoading: isLoading ?? this.isLoading,
//       isMarking: isMarking ?? this.isMarking,
//       error: error,
//     );
//   }
// }

// // Provider for NotificationRepository
// final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
//   return NotificationRepository(Dio());
// });

// // StateNotifier for NotificationState
// final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
//   return NotificationNotifier(ref.watch(notificationRepositoryProvider));
// });

// class NotificationNotifier extends StateNotifier<NotificationState> {
//   final NotificationRepository _repository;

//   NotificationNotifier(this._repository) : super(NotificationState()) {
//     loadNotifications();
//   }

//   Future<void> loadNotifications() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final notifications = await _repository.fetchNotifications();
//       state = state.copyWith(notifications: notifications, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> markNotificationsAsRead(List<String> notificationIds) async {
//     state = state.copyWith(isMarking: true, error: null);
//     try {
//       await _repository.markAsRead(notificationIds);
//       // Update the state to mark notifications as read
//       state = state.copyWith(
//         notifications: state.notifications.map((n) {
//           if (notificationIds.contains(n.id)) {
//             return n.copyWith(isRead: true);
//           }
//           return n;
//         }).toList(),
//         isMarking: false,
//       );
//     } catch (e) {
//       state = state.copyWith(isMarking: false, error: e.toString());
//     }
//   }
// }
