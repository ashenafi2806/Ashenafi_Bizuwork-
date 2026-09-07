import 'package:dio/dio.dart';
import '../../core/network/dio/dio_client.dart';
import '../../core/network/dio/network_exception_handler.dart';

class RemoteDataSource {
  final DioClient dioClient;

  RemoteDataSource({required this.dioClient});

  Future<Map<String, dynamic>> login(String pin) async {
    try {
      final response = await dioClient.post('/login', data: {'pin': pin});
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw Exception('Unable to sign in right now');
    }
  }

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
