// lib/repositories/post_repository.dart
import 'package:dio/dio.dart';
import 'package:dpla/models/post.dart';
import 'package:dpla/core/token_storage.dart';
import 'package:dpla/core/exception.dart';

class PostRepository {
  final Dio _dio;

  PostRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.40.230:5000/api'; 
  }

  Future<List<Post>> fetchFeed({int page = 1, int limit = 10}) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/posts/feed',
          queryParameters: {
            'page': page,
            'limit': limit,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final postsData = data['posts'] as List;
        print('Fetched ${postsData.length} posts.');
        return postsData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to fetch feed');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.post('/posts/$postId/like',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode != 200) {
        throw ApiException('Failed to like post');
      }
      print('Post $postId liked successfully.');
    } catch (e) {
      print('Error in likePost: $e');
      throw ApiException(e.toString());
    }
  }

  Future<void> commentOnPost(String postId, String content) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.post('/posts/$postId/comment',
          data: {'content': content},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode != 200) {
        throw ApiException('Failed to comment on post');
      }
      print('Comment added to post $postId successfully.');
    } catch (e) {
      print('Error in commentOnPost: $e');
      throw ApiException(e.toString());
    }
  }

  Future<void> createPost(String content) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.post('/posts',
          data: {'content': content},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode != 200) {
        throw ApiException('Failed to create post');
      }
      print('Post created successfully.');
    } catch (e) {
      print('Error in createPost: $e');
      throw ApiException(e.toString());
    }
  }
}
