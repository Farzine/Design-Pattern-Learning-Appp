// lib/repositories/like_repository.dart
import 'package:dio/dio.dart';
import 'package:dpla/core/token_storage.dart';
import 'package:dpla/core/exception.dart';

class LikeRepository {
  final Dio _dio;

  LikeRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.40.230:5000/api';
  }

  Future<void> likePost(String postId) async {
    final token = await TokenStorage.getToken();
    final response = await _dio.post('/posts/$postId/like',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode != 200) {
      throw ApiException('Failed to like post');
    }
  }
}
