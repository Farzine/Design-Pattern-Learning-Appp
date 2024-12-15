//user_repository.dart
import 'package:dio/dio.dart';
import 'package:dpla/core/exception.dart';
import 'package:dpla/core/token_storage.dart';
import 'package:dpla/models/user.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio) {
    _dio.options.baseUrl = 'http://10.201.40.230:5000/api';

    // Add interceptors for handling tokens and errors globally
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach the token to every request if available
          String? token = await TokenStorage.getToken();
          print('Attaching token: $token'); // Debugging
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError error, handler) {
          // Handle global errors if necessary
          return handler.next(error);
        },
      ),
    );
  }

  Future<User> fetchUserProfile() async {
  try {
    // Retrieve the token from storage
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw ApiException('No token found');
    }

    // Decode the token to extract the userId
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    print('Decoded token: $decodedToken');

    final userMap = decodedToken['user'] as Map<String, dynamic>?;

    if (userMap == null || !userMap.containsKey('id')) {
      throw ApiException('Invalid token: userId not found');
    }

    final userId = userMap['id'];
    print('User ID: $userId');

    // Make an API call to fetch the user profile
    final response = await _dio.get(
      '/users/$userId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

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
    final response = await _dio.get(
      '/users/$userId/followers',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      final data = response.data; // Response is likely a Map
      final followers = data['followers'] as List; // Extract the list of followers
      return followers.map((json) => User.fromJson(json)).toList();
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
  }) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.put('/users/$userId',
          data: {
            'name': name,
            'email': email,
            'birthdate': birthdate?.toIso8601String(),
            'location': {
              'latitude': latitude,
              'longitude': longitude,
            },
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

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
