// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/models/practice_question.dart';
// import 'package:design_patterns_app/core/exceptions.dart';
// import 'package:design_patterns_app/core/token_storage.dart';

// class PracticeRepository {
//   final Dio _dio;

//   PracticeRepository(this._dio) {
//     _dio.options.baseUrl = 'http://localhost:5000/api';
//   }

//   Future<List<PracticeQuestion>> fetchPracticeQuestions(String patternId) async {
//     try {
//       final token = await TokenStorage.getToken();
//       final response = await _dio.get('/design-patterns/$patternId/practice-questions',
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         return (response.data as List).map((json) => PracticeQuestion.fromJson(json)).toList();
//       } else {
//         throw ApiException('Failed to fetch practice questions');
//       }
//     } catch (e) {
//       throw ApiException(e.toString());
//     }
//   }

//   Future<String> submitAnswers(String patternId, Map<int, String> answers) async {
//     try {
//       final token = await TokenStorage.getToken();
//       // Assuming the API expects a list of answers with question indices
//       final response = await _dio.post('/design-patterns/$patternId/submit-answer',
//           data: {'answers': answers},
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         return response.data['feedback'] as String;
//       } else {
//         throw ApiException('Failed to submit answers');
//       }
//     } catch (e) {
//       throw ApiException(e.toString());
//     }
//   }
// }
