import 'package:dio/dio.dart';
import 'package:dpla/models/user_progress.dart';
import 'package:dpla/core/exception.dart';
import 'package:dpla/core/token_storage.dart';

class UserProgressRepository {
  final Dio _dio;

  UserProgressRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.41.126:5000/api'; 
  }


  Future<List<UserProgress>> fetchAllUserProgress() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/progress',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        final data = response.data['progress'] as List;
        return data.map((json) => UserProgress.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; 
      } else {
        throw ApiException('Failed to fetch user progress');
      }
    } on DioError catch (e) {
      throw ApiException(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }


  Future<UserProgress> fetchProgressByDesignPattern(String patternId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/progress/$patternId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        return UserProgress.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ApiException('No progress found for this design pattern');
      } else {
        throw ApiException('Failed to fetch progress');
      }
    } on DioError catch (e) {
      throw ApiException(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
