import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String pin) async {
    final response = await remoteDataSource.login(pin);
    final data = Map<String, dynamic>.from(response['data'] as Map);
    final user = Map<String, dynamic>.from(data['user'] as Map);
    return UserEntity(
      id: user['id'] as String? ?? '',
      name: user['name'] as String? ?? 'M-PESA customer',
      phoneNumber: user['phoneNumber'] as String? ?? '',
      balance: (user['balance'] as num?)?.toDouble() ?? 0,
      currency: user['currency'] as String? ?? 'ETB',
      token: data['token'] as String? ?? '',
    );
  }
}