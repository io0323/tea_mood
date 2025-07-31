import '../entities/tea_log.dart';
import '../repositories/tea_log_repository.dart';

class GetTeaLogsUseCase {
  final TeaLogRepository repository;

  GetTeaLogsUseCase(this.repository);

  Future<List<TeaLog>> call() async {
    return await repository.getAllTeaLogs();
  }
}

class GetTeaLogsByDateUseCase {
  final TeaLogRepository repository;

  GetTeaLogsByDateUseCase(this.repository);

  Future<List<TeaLog>> call(DateTime date) async {
    return await repository.getTeaLogsByDate(date);
  }
}

class GetTeaLogsByDateRangeUseCase {
  final TeaLogRepository repository;

  GetTeaLogsByDateRangeUseCase(this.repository);

  Future<List<TeaLog>> call(DateTime startDate, DateTime endDate) async {
    return await repository.getTeaLogsByDateRange(startDate, endDate);
  }
}

class GetTeaLogByIdUseCase {
  final TeaLogRepository repository;

  GetTeaLogByIdUseCase(this.repository);

  Future<TeaLog?> call(String id) async {
    return await repository.getTeaLogById(id);
  }
}

class AddTeaLogUseCase {
  final TeaLogRepository repository;

  AddTeaLogUseCase(this.repository);

  Future<void> call(TeaLog teaLog) async {
    await repository.addTeaLog(teaLog);
  }
}

class UpdateTeaLogUseCase {
  final TeaLogRepository repository;

  UpdateTeaLogUseCase(this.repository);

  Future<void> call(TeaLog teaLog) async {
    await repository.updateTeaLog(teaLog);
  }
}

class DeleteTeaLogUseCase {
  final TeaLogRepository repository;

  DeleteTeaLogUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTeaLog(id);
  }
}

class GetTotalCaffeineByDateUseCase {
  final TeaLogRepository repository;

  GetTotalCaffeineByDateUseCase(this.repository);

  Future<int> call(DateTime date) async {
    return await repository.getTotalCaffeineByDate(date);
  }
}

class GetMoodStatsByDateRangeUseCase {
  final TeaLogRepository repository;

  GetMoodStatsByDateRangeUseCase(this.repository);

  Future<Map<String, int>> call(DateTime startDate, DateTime endDate) async {
    return await repository.getMoodStatsByDateRange(startDate, endDate);
  }
}

class GetTeaTypeStatsByDateRangeUseCase {
  final TeaLogRepository repository;

  GetTeaTypeStatsByDateRangeUseCase(this.repository);

  Future<Map<String, int>> call(DateTime startDate, DateTime endDate) async {
    return await repository.getTeaTypeStatsByDateRange(startDate, endDate);
  }
} 