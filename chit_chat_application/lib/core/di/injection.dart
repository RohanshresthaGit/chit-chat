import 'package:chit_chat_application/core/logging/logging_service.dart';
import 'package:chit_chat_application/core/navigation/navigation_service.dart';
import 'package:chit_chat_application/core/network/dio_client.dart';
import 'package:chit_chat_application/core/network/network_client.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Logging service
  getIt.registerLazySingleton<LoggingService>(() => LoggingService());

  // Network client
  getIt.registerLazySingleton<NetworkClient>(
    () => NetworkClient(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService.instance,
  );
}

LoggingService get loggingService => getIt<LoggingService>();
NetworkClient get networkClient => getIt<NetworkClient>();
NavigationService get nav => getIt<NavigationService>();
