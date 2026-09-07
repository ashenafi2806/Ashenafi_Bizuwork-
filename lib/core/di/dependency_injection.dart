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
