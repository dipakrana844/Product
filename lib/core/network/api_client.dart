import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String? message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in with server.';
        break;
      case DioExceptionType.receiveTimeout:
        message =
            'Server is taking too long to respond. Please try again later.';
        break;
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          final data = error.response!.data;
          if (data is Map) {
            // Check for localized/detailed validation error lists (e.g. NestJS)
            if (data['error'] is List) {
              final errorList = data['error'] as List;
              if (errorList.isNotEmpty && errorList.first is Map) {
                final firstErr = errorList.first as Map;
                if (firstErr['constraints'] is List &&
                    (firstErr['constraints'] as List).isNotEmpty) {
                  message = (firstErr['constraints'] as List).first.toString();
                }
              }
            }

            // Fallback to other common message keys
            message ??= data['message']?.toString();
            message ??= data['error']?.toString();
            message ??= data['msg']?.toString();

            final Map? responseMap = data;
            final String responseString =
                data?.toString() ?? error.response?.toString() ?? '';

            bool isOnboardingMissing =
                error.response?.statusCode == 403 &&
                (responseString.contains('CREATE_ORGANIZATION') ||
                    responseString.contains('Onboarding is not completed'));

            // Extra check for data map fields
            if (!isOnboardingMissing && responseMap != null) {
              final msg = responseMap['message']?.toString() ?? '';
              final step = responseMap['step']?.toString() ?? '';
              if (msg.contains('Onboarding') || step == 'CREATE_ORGANIZATION') {
                isOnboardingMissing = true;
              }
            }

            if (isOnboardingMissing) {
              return OnboardingRequiredException(
                message ?? 'Onboarding required',
                'CREATE_ORGANIZATION',
              );
            }

            if (message == null && data['errors'] is List) {
              final errors = data['errors'] as List;
              if (errors.isNotEmpty) {
                message = errors.first.toString();
              }
            }
          } else if (data is String) {
            message = data;
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request to server was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      default:
        message = 'An unexpected error occurred.';
    }

    message ??= error.message;
    message ??= 'An unexpected error occurred';

    return ServerException(message);
  }
}
