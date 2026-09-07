import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add common headers or modify the request if needed.
    options.headers.addAll({
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer YOUR_TOKEN',
    });
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle or modify the response globally if needed.
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors globally, such as logging or showing error messages.
    super.onError(err, handler);
  }
}
