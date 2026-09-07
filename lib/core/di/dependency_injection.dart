import 'package:get_it/get_it.dart';
import '../../core/constants/constants.dart';
import '../../core/network/dio/dio_client.dart';
import '../../data/data_sources/remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../presentation/bloc/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjector() async {
  // 1. Environment variables
  // await dotenv.load(fileName: ".env");

  // 2. Core (Network)
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: Constants.loginBaseUrl),
  );

  // 3. Data Sources
  getIt.registerLazySingleton(() => RemoteDataSource(dioClient: getIt()));

  // 4. Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // 5. Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));

  // 6. Blocs
  getIt.registerFactory(() => AuthCubit(loginUseCase: getIt()));
}
