import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../config/env_config.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  static const String tokenKey = 'auth_token';

  static void initialize(GetStorage storage) {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storage.read<String>(tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
  }

  static Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return dio.get(path, queryParameters: query);
  }

  static Future<Response<dynamic>> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }

  static Future<Response<dynamic>> patch(String path, {dynamic data}) {
    return dio.patch(path, data: data);
  }

  static Future<Response<dynamic>> delete(String path, {dynamic data}) {
    return dio.delete(path, data: data);
  }
}
