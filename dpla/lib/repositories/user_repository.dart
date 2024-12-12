//user_repository.dart
import 'package:dio/dio.dart';
import 'package:dpla/models/user.dart';
import 'package:dpla/core/token_storage.dart';
import 'package:dpla/core/exception.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.51.182:5000/api';
  }

  Future<User> fetchUserProfile(String userId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get('/users/$userId',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw ApiException('Failed to fetch user profile');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<User>> fetchFollowing(String userId) async {
    try {
      final token = await TokenStorage.getToken();
      // Assuming there's an endpoint to get following users
      final response = await _dio.get('/users/$userId/following',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => User.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to fetch following users');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    DateTime? birthdate,
    required double latitude,
    required double longitude,
    String? profilePictureUrl,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.put('/users/$userId', data: {
        'name': name,
        'email': email,
        'birthdate': birthdate?.toIso8601String(),
        'location': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'profile_picture': profilePictureUrl,
      }, options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode != 200) {
        throw ApiException('Failed to update profile');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> followUser(String userId, String targetUserId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.post('/users/$targetUserId/follow',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode != 200) {
        throw ApiException('Failed to follow user');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> unfollowUser(String userId, String targetUserId) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.post('/users/$targetUserId/unfollow',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode != 200) {
        throw ApiException('Failed to unfollow user');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
