import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/tea_log.dart';
import '../../domain/repositories/tea_log_repository.dart';

class TeaLogRepositoryImpl implements TeaLogRepository {
  final List<TeaLog> _teaLogs = [];

  TeaLogRepositoryImpl([Box<TeaLog>? teaLogsBox]) {
    // Initialize with empty list for now
  }

  @override
  Future<List<TeaLog>> getAllTeaLogs() async {
    return _teaLogs.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  Future<List<TeaLog>> getTeaLogsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _teaLogs
        .where((log) => log.dateTime.isAfter(startOfDay) && log.dateTime.isBefore(endOfDay))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  Future<List<TeaLog>> getTeaLogsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      print('Getting tea logs by date range: $startDate to $endDate');
      final startOfDay = DateTime(startDate.year, startDate.month, startDate.day);
      final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      
      print('Filtering logs between: $startOfDay and $endOfDay');
      print('Total logs in repository: ${_teaLogs.length}');

      final result = _teaLogs
          .where((log) => log.dateTime.isAfter(startOfDay) && log.dateTime.isBefore(endOfDay))
          .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
      
      print('Filtered logs: ${result.length}');
      return result;
    } catch (e) {
      print('Error in getTeaLogsByDateRange: $e');
      rethrow;
    }
  }

  @override
  Future<TeaLog?> getTeaLogById(String id) async {
    try {
      return _teaLogs.firstWhere((log) => log.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addTeaLog(TeaLog teaLog) async {
    _teaLogs.add(teaLog);
  }

  @override
  Future<void> updateTeaLog(TeaLog teaLog) async {
    final index = _teaLogs.indexWhere((log) => log.id == teaLog.id);
    if (index != -1) {
      _teaLogs[index] = teaLog;
    }
  }

  @override
  Future<void> deleteTeaLog(String id) async {
    _teaLogs.removeWhere((log) => log.id == id);
  }

  @override
  Future<int> getTotalCaffeineByDate(DateTime date) async {
    final logs = await getTeaLogsByDate(date);
    return logs.fold<int>(0, (sum, log) => sum + log.caffeineMg);
  }

  @override
  Future<Map<String, int>> getMoodStatsByDateRange(DateTime startDate, DateTime endDate) async {
    final logs = await getTeaLogsByDateRange(startDate, endDate);
    final moodStats = <String, int>{};

    for (final log in logs) {
      moodStats[log.mood] = (moodStats[log.mood] ?? 0) + 1;
    }

    return moodStats;
  }

  @override
  Future<Map<String, int>> getTeaTypeStatsByDateRange(DateTime startDate, DateTime endDate) async {
    final logs = await getTeaLogsByDateRange(startDate, endDate);
    final teaTypeStats = <String, int>{};

    for (final log in logs) {
      teaTypeStats[log.teaType] = (teaTypeStats[log.teaType] ?? 0) + 1;
    }

    return teaTypeStats;
  }
} 