import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/tea_log_repository_impl.dart';
import '../../domain/entities/tea_log.dart';
import '../../domain/repositories/tea_log_repository.dart';
import '../../domain/usecases/tea_log_usecases.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters - temporarily disabled
    // if (!Hive.isAdapterRegistered(0)) {
    //   Hive.registerAdapter(TeaLogAdapter());
    // }

    // Open Hive boxes - temporarily disabled
    // final teaLogsBox = await Hive.openBox<TeaLog>(AppConstants.teaLogsBox);

    // Repository
    sl.registerLazySingleton<TeaLogRepository>(() => TeaLogRepositoryImpl());

    // Use cases
    sl.registerLazySingleton(() => GetTeaLogsUseCase(sl()));
    sl.registerLazySingleton(() => GetTeaLogsByDateUseCase(sl()));
    sl.registerLazySingleton(() => GetTeaLogsByDateRangeUseCase(sl()));
    sl.registerLazySingleton(() => GetTeaLogByIdUseCase(sl()));
    sl.registerLazySingleton(() => AddTeaLogUseCase(sl()));
    sl.registerLazySingleton(() => UpdateTeaLogUseCase(sl()));
    sl.registerLazySingleton(() => DeleteTeaLogUseCase(sl()));
    sl.registerLazySingleton(() => GetTotalCaffeineByDateUseCase(sl()));
    sl.registerLazySingleton(() => GetMoodStatsByDateRangeUseCase(sl()));
    sl.registerLazySingleton(() => GetTeaTypeStatsByDateRangeUseCase(sl()));
  } catch (e, stackTrace) {
    print('DI initialization error: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
