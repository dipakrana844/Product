import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  final bool enableLog;
  final bool showSensitiveData;

  LoggingInterceptor({
    this.enableLog = true,
    this.showSensitiveData = true, // set false if you want masking
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enableLog) {
      handler.next(options);
      return;
    }

    final curlCommand = _generateCurl(options);

    log(
      '''
═══════════════════════════════════════════════
🌍 API REQUEST
═══════════════════════════════════════════════
URL     : ${options.uri}
METHOD  : ${options.method}
HEADERS : ${_prettyJson(_logHeaders(options.headers))}
QUERY   : ${_prettyJson(options.queryParameters)}
BODY    : ${_prettyJson(options.data)}

📌 cURL (Copy & Test in Postman):
$curlCommand
═══════════════════════════════════════════════
''',
      name: 'API_REQUEST',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enableLog) {
      handler.next(response);
      return;
    }

    log(
      '''
═══════════════════════════════════════════════
✅ API RESPONSE
═══════════════════════════════════════════════
URL     : ${response.requestOptions.uri}
STATUS  : ${response.statusCode}
DATA    : ${_prettyJson(response.data)}
═══════════════════════════════════════════════
''',
      name: 'API_RESPONSE',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enableLog) {
      handler.next(err);
      return;
    }

    log(
      '''
═══════════════════════════════════════════════
❌ API ERROR
═══════════════════════════════════════════════
URL     : ${err.requestOptions.uri}
METHOD  : ${err.requestOptions.method}
STATUS  : ${err.response?.statusCode}
MESSAGE : ${err.message}
DATA    : ${_prettyJson(err.response?.data)}
═══════════════════════════════════════════════
''',
      name: 'API_ERROR',
    );

    handler.next(err);
  }

  /// Generate cURL command (with token included)
  String _generateCurl(RequestOptions options) {
    final buffer = StringBuffer();

    buffer.write("curl -X ${options.method} '${options.uri}'");

    options.headers.forEach((key, value) {
      buffer.write(" \\\n  -H '$key: $value'");
    });

    if (options.data != null) {
      final data = options.data is String
          ? options.data
          : jsonEncode(options.data);

      buffer.write(" \\\n  -d '${data.replaceAll("'", r"'\''")}'");
    }

    return buffer.toString();
  }

  String _prettyJson(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }

  /// Mask token in console if needed
  Map<String, dynamic> _logHeaders(Map<String, dynamic> headers) {
    if (showSensitiveData) return headers;

    final updated = Map<String, dynamic>.from(headers);

    if (updated.containsKey('Authorization')) {
      updated['Authorization'] = 'Bearer ********';
    }

    return updated;
  }
}
