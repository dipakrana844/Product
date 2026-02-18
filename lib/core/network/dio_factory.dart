import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import '../storage/token_storage.dart';
import 'package:flutter/foundation.dart';

class DioFactory {
  static Dio create(TokenStorage tokenStorage) {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'accept': ApiConstants.accept,
        'Content-Type': ApiConstants.contentType,
      },
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage),
      LoggingInterceptor(
        enableLog: !kReleaseMode,
        showSensitiveData: !kReleaseMode,
      ),
    ]);

    return dio;
  }
}
