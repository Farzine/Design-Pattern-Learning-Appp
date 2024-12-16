//repositories/design_pattern_repository.dart
import 'package:dio/dio.dart';
import 'package:dpla/models/design_pattern.dart';
import 'package:dpla/core/exception.dart';
import 'package:dpla/core/token_storage.dart';

class DesignPatternRepository {
  final Dio _dio;

  DesignPatternRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.40.230:5000/api';
  }

  Future<List<DesignPattern>> fetchDesignPatterns() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/design-patterns',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => DesignPattern.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to fetch design patterns');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<DesignPattern> fetchDesignPatternDetail(String patternId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/design-patterns/$patternId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return DesignPattern.fromJson(response.data);
      } else {
        throw ApiException('Failed to fetch design pattern details');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
  /// Searches design patterns based on a query string using semantic search.
  Future<List<DesignPattern>> searchDesignPatterns(String query) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/design-patterns/search',
          queryParameters: {'search': query},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        final data = response.data['patterns'] as List;
        return data.map((json) => DesignPattern.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to search design patterns');
      }
    } on DioError catch (e) {
      throw ApiException(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}


