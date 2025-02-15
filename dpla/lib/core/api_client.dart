
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio.options.baseUrl = 'http://10.201.41.126:5000/api';
    _dio.options.headers['Content-Type'] = 'application/json';

    _dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String? token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('Backend connected successfully: ${response.statusCode}');
      return handler.next(response);
    },
    onError: (DioError error, handler) {
      print('Backend connection failed: ${error.message}');
      return handler.next(error);
    },
  ));

  }

  Dio get client => _dio;
}
