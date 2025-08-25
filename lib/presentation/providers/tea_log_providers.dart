import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/tea_log.dart';
import '../../domain/usecases/tea_log_usecases.dart';

// TeaLogs Provider
final teaLogsProvider = FutureProvider<List<TeaLog>>((ref) async {
  return await sl<GetTeaLogsUseCase>().call();
});

// TeaLogs by Date Provider
final teaLogsByDateProvider = FutureProvider.family<List<TeaLog>, DateTime>((
  ref,
  date,
) async {
  return await sl<GetTeaLogsByDateUseCase>().call(date);
});

// TeaLogs by Date Range Provider
final teaLogsByDateRangeProvider =
    FutureProvider.family<
      List<TeaLog>,
      ({DateTime startDate, DateTime endDate})
    >((ref, params) async {
      try {
        print(
          'Calling GetTeaLogsByDateRangeUseCase: ${params.startDate} to ${params.endDate}',
        );
        final result = await sl<GetTeaLogsByDateRangeUseCase>().call(
          params.startDate,
          params.endDate,
        );
        print('GetTeaLogsByDateRangeUseCase result: ${result.length} logs');
        return result;
      } catch (e, stackTrace) {
        print('Error in teaLogsByDateRangeProvider: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

// TeaLog by ID Provider
final teaLogByIdProvider = FutureProvider.family<TeaLog?, String>((
  ref,
  id,
) async {
  return await sl<GetTeaLogByIdUseCase>().call(id);
});

// Total Caffeine by Date Provider
final totalCaffeineByDateProvider = FutureProvider.family<int, DateTime>((
  ref,
  date,
) async {
  return await sl<GetTotalCaffeineByDateUseCase>().call(date);
});

// Mood Stats by Date Range Provider
final moodStatsByDateRangeProvider =
    FutureProvider.family<
      Map<String, int>,
      ({DateTime startDate, DateTime endDate})
    >((ref, params) async {
      return await sl<GetMoodStatsByDateRangeUseCase>().call(
        params.startDate,
        params.endDate,
      );
    });

// Tea Type Stats by Date Range Provider
final teaTypeStatsByDateRangeProvider =
    FutureProvider.family<
      Map<String, int>,
      ({DateTime startDate, DateTime endDate})
    >((ref, params) async {
      return await sl<GetTeaTypeStatsByDateRangeUseCase>().call(
        params.startDate,
        params.endDate,
      );
    });

// TeaLog Notifier Provider
final teaLogNotifierProvider =
    StateNotifierProvider<TeaLogNotifier, AsyncValue<void>>((ref) {
      return TeaLogNotifier(ref);
    });

class TeaLogNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  TeaLogNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> addTeaLog(TeaLog teaLog) async {
    state = const AsyncValue.loading();
    try {
      await sl<AddTeaLogUseCase>().call(teaLog);
      _ref.invalidate(teaLogsProvider);
      _ref.invalidate(teaLogsByDateProvider(teaLog.dateTime));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTeaLog(TeaLog teaLog) async {
    state = const AsyncValue.loading();
    try {
      await sl<UpdateTeaLogUseCase>().call(teaLog);
      _ref.invalidate(teaLogsProvider);
      _ref.invalidate(teaLogsByDateProvider(teaLog.dateTime));
      _ref.invalidate(teaLogByIdProvider(teaLog.id));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteTeaLog(String id) async {
    state = const AsyncValue.loading();
    try {
      await sl<DeleteTeaLogUseCase>().call(id);
      _ref.invalidate(teaLogsProvider);
      _ref.invalidate(teaLogByIdProvider(id));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
