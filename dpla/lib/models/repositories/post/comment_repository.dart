import 'package:dio/dio.dart';
import 'package:dpla/core/token_storage.dart';
import 'package:dpla/core/exception.dart';

class CommentRepository {
  final Dio _dio;

  CommentRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.41.126:5000/api';
  }

  Future<void> commentOnPost(String postId, String content) async {
    final token = await TokenStorage.getToken();
    final response = await _dio.post('/posts/$postId/comment',
        data: {'content': content},
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode != 200) {
      throw ApiException('Failed to comment on post');
    }
  }
}
