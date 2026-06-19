import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/token_storage.dart';

Dio createDio(TokenStorage tokenStorage) {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL']!));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await tokenStorage.getToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
      handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        tokenStorage.deleteToken();
      }
      handler.next(error);
    },
  ));

  return dio;
}