import 'package:dio/dio.dart';
import 'package:dpla/models/practice_question.dart';
import 'package:dpla/core/exception.dart';
import 'package:dpla/core/token_storage.dart';

class PracticeRepository {
  final Dio _dio;

  PracticeRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.41.126:5000/api'; 
  }

  Future<List<PracticeQuestion>> fetchPracticeQuestions(String patternId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/design-patterns/practice/$patternId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return (response.data['questions'] as List)
            .map((json) => PracticeQuestion.fromJson(json))
            .toList();
      } else {
        throw ApiException('Failed to fetch practice questions');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> submitAnswers(String patternId, List<String> answers) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.post('/design-patterns/practice/$patternId/submit',
          data: {'answers': answers},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return response.data; 
      } else {
        throw ApiException('Failed to submit answers');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
