import '../entities/tea_log.dart';

abstract class TeaLogRepository {
  Future<List<TeaLog>> getAllTeaLogs();
  Future<List<TeaLog>> getTeaLogsByDate(DateTime date);
  Future<List<TeaLog>> getTeaLogsByDateRange(DateTime startDate, DateTime endDate);
  Future<TeaLog?> getTeaLogById(String id);
  Future<void> addTeaLog(TeaLog teaLog);
  Future<void> updateTeaLog(TeaLog teaLog);
  Future<void> deleteTeaLog(String id);
  Future<int> getTotalCaffeineByDate(DateTime date);
  Future<Map<String, int>> getMoodStatsByDateRange(DateTime startDate, DateTime endDate);
  Future<Map<String, int>> getTeaTypeStatsByDateRange(DateTime startDate, DateTime endDate);
} 