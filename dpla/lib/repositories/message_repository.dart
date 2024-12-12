// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/models/message.dart';
// import 'package:design_patterns_app/core/exceptions.dart';
// import 'package:design_patterns_app/core/token_storage.dart';

// class MessageRepository {
//   final Dio _dio;

//   MessageRepository(this._dio) {
//     _dio.options.baseUrl = 'http://localhost:5000/api';
//   }

//   Future<List<Message>> fetchMessages(String chatWithUserId) async {
//     try {
//       final token = await TokenStorage.getToken();
//       final response = await _dio.get('/messages/$chatWithUserId',
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         return (response.data as List).map((json) => Message.fromJson(json)).toList();
//       } else {
//         throw ApiException('Failed to fetch messages');
//       }
//     } catch (e) {
//       throw ApiException(e.toString());
//     }
//   }

//   Future<Message> sendMessage(String chatWithUserId, String content) async {
//     try {
//       final token = await TokenStorage.getToken();
//       final response = await _dio.post('/messages',
//           data: {
//             'receiver_id': chatWithUserId,
//             'content': content,
//           },
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         return Message.fromJson(response.data);
//       } else {
//         throw ApiException('Failed to send message');
//       }
//     } catch (e) {
//       throw ApiException(e.toString());
//     }
//   }
// }
