import 'package:dio/dio.dart';
import 'package:dpla/models/auth_response.dart';
import 'package:dpla/core/token_storage.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required DateTime birthdate,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'birthdate': birthdate.toIso8601String(),
        'location': {
          'type': 'Point',
          'coordinates': [longitude, latitude], 
        },
      });
      print('Register data: $response');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        await TokenStorage.saveToken(data['token']);
        return AuthResponse.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to register');
      }
    } on DioError catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        await TokenStorage.saveToken(data['token']);
        return AuthResponse.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to login');
      }
    } on DioError catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      final token = await TokenStorage.getToken();
      if (token != null) {
        await _dio.post('/auth/logout', options: Options(headers: {'Authorization': 'Bearer $token'}));
        await TokenStorage.deleteToken();
      }
    } on DioError catch (e) {
      throw Exception('Logout failed: ${e.message}');
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
