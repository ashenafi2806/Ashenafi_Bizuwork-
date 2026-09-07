# Flutter Clean Architecture Template

This document provides a comprehensive guide and boilerplate code for setting up a Flutter project using **Clean Architecture**, **Bloc** (State Management), **GetIt** (Dependency Injection), and **Dio** (Networking).

## Directory Structure
A standard clean architecture structure for a Flutter project:

```text
lib/
├── core/
│   ├── constants/             # App-wide constants (e.g., API keys, URLs)
│   ├── di/                    # Dependency Injection setup (GetIt)
│   ├── network/               # Networking configuration (Dio client, interceptors, error handling)
│   └── error/                 # Global error handling and exceptions
├── data/
│   ├── data_sources/          # Remote and Local data sources (API calls, Database)
│   ├── models/                # Data models (JSON serialization)
│   └── repositories/          # Repository implementations
├── domain/
│   ├── entities/              # Core business logic entities
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business logic use cases
├── presentation/
│   ├── bloc/                  # State management (Bloc/Cubit)
│   ├── pages/                 # UI Screens
│   └── widgets/               # Reusable UI components
└── main.dart                  # App entry point
```

## Dependencies
Add the following core dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.5.0
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  get_it: ^7.7.0
  flutter_dotenv: ^5.1.0
  # Other necessary packages
```

---

## 1. Network Layer (Dio)

### Dio Interceptor
Located in `lib/core/network/dio/dio_interceptor.dart`

```dart
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
```

### Dio Client
Located in `lib/core/network/dio/dio_client.dart`

```dart
import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    )..interceptors.add(ApiInterceptor());
  }

  // GET Request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // POST Request
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  // PUT Request
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }

  // DELETE Request
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }
}
```

### Network Exception Handler
Located in `lib/core/network/dio/network_exception_handler.dart`

```dart
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

class NetworkException extends Equatable implements Exception {
  late final String message;
  late final int? statusCode;

  NetworkException.fromDioError(DioException dioException) {
    statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.badResponse:
        message = 'Received invalid response with status code: ${dioException.response?.statusCode}';
        break;
      case DioExceptionType.badCertificate:
        message = 'The certificate provided is invalid';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection to the server timed out';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Timeout occurred while sending the request';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Timeout occurred while receiving data from the server';
        break;
      case DioExceptionType.cancel:
        message = 'The request to the server was cancelled';
        break;
      case DioExceptionType.connectionError:
        if (dioException.error is SocketException) {
          message = 'No internet connection. Please check your network settings';
        } else {
          message = 'Network connection error occurred';
        }
        break;
      case DioExceptionType.unknown:
      default:
        message = 'An unknown error occurred';
        break;
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
}
```

---

## 2. Data Layer (Data Sources with GET, POST, PUT)
Located in `lib/data/data_sources/remote_data_source.dart`

This is a robust boilerplate for handling different types of HTTP requests using our custom `DioClient` and `NetworkException`.

```dart
import 'package:dio/dio.dart';
import '../../core/network/dio/dio_client.dart';
import '../../core/network/dio/network_exception_handler.dart';

class RemoteDataSource {
  final DioClient dioClient;

  RemoteDataSource({required this.dioClient});

  // Example GET request
  Future<dynamic> fetchData(String id) async {
    try {
      final response = await dioClient.get('/endpoint/$id');
      // Parse response.data into a Model
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch data');
    }
  }

  // Example POST request
  Future<dynamic> createData(Map<String, dynamic> body) async {
    try {
      final response = await dioClient.post(
        '/endpoint',
        data: body,
      );
      // Parse response.data into a Model
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw Exception('Failed to create data');
    }
  }

  // Example PUT request
  Future<dynamic> updateData(String id, Map<String, dynamic> body) async {
    try {
      final response = await dioClient.put(
        '/endpoint/$id',
        data: body,
      );
      // Parse response.data into a Model
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw Exception('Failed to update data');
    }
  }
}
```

---

## 3. Dependency Injection (GetIt)
Located in `lib/core/di/dependency_injection.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/network/dio/dio_client.dart';
// Import your repositories, use cases, and blocs...

final GetIt getIt = GetIt.instance;

Future<void> setupInjector() async {
  // 1. Environment variables
  // await dotenv.load(fileName: ".env");

  // 2. Core (Network)
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: 'https://api.example.com'),
  );

  // 3. Data Sources
  // getIt.registerLazySingleton(() => RemoteDataSource(dioClient: getIt()));

  // 4. Repositories
  // getIt.registerLazySingleton<RepositoryInterface>(
  //     () => RepositoryImpl(remoteDataSource: getIt()));

  // 5. Use Cases
  // getIt.registerLazySingleton(() => UseCase(getIt()));

  // 6. Blocs
  // getIt.registerFactory(() => FeatureBloc(useCase: getIt()));
}
```

## Setup Instructions

1. Copy the `core` folder structure and files into your new project.
2. Initialize `setupInjector()` inside your `main.dart` before `runApp()`.
3. Use `GetIt.I<YourBloc>()` to inject dependencies into your UI or BlocProvider.
