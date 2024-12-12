// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/models/notification.dart';
// import 'package:design_patterns_app/core/exceptions.dart';
// import 'package:design_patterns_app/core/token_storage.dart';

// class NotificationRepository {
//   final Dio _dio;

//   NotificationRepository(this._dio) {
//     _dio.options.baseUrl = 'http://localhost:5000/api';
//   }

//   Future<List<AppNotification>> fetchNotifications() async {
//     try {
//       final token = await TokenStorage.getToken();
//       final response = await _dio.get('/notifications',
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         return (response.data as List).map((json) => AppNotification.fromJson(json)).toList();
//       } else {
//         throw ApiException('Failed to fetch notifications');
//       }
//     } catch (e) {
//       throw ApiException(e.toString());
//     }
//   }

//   Future<void> markAsRead(List<String> notificationIds) async {
//     try {
//       final token = await TokenStorage.getToken();
//       final response = await _dio.post('/notifications/mark-as-read',
//           data: {'notification_ids': notificationIds},
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode != 200) {
//         throw ApiException('Failed to mark notifications as read');
//       }
//     } catch (e) {
//       throw ApiException(e.toString());
//     }
//   }
// }
