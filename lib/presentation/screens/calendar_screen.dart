import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/tea_log.dart';
import '../providers/tea_log_providers.dart';
import '../widgets/tea_log_detail_dialog.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<TeaLog>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final teaLogsAsync = ref.watch(teaLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: teaLogsAsync.when(
        data: (teaLogs) {
          _events = _groupTeaLogsByDate(teaLogs);
          return Column(
            children: [
              TableCalendar<TeaLog>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => _getEventsForDay(day),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  markersMaxCount: 3,
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _selectedDay == null
                    ? const Center(child: Text('日付を選択してください'))
                    : _buildEventList(_selectedDay!),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('エラー: $error')),
      ),
    );
  }

  Map<DateTime, List<TeaLog>> _groupTeaLogsByDate(List<TeaLog> teaLogs) {
    final events = <DateTime, List<TeaLog>>{};
    for (final teaLog in teaLogs) {
      final date = DateTime(
        teaLog.dateTime.year,
        teaLog.dateTime.month,
        teaLog.dateTime.day,
      );
      if (events[date] == null) events[date] = [];
      events[date]!.add(teaLog);
    }
    return events;
  }

  List<TeaLog> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildEventList(DateTime selectedDay) {
    final events = _getEventsForDay(selectedDay);
    final totalCaffeine = events.fold<int>(
      0,
      (sum, log) => sum + log.caffeineMg,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('yyyy年M月d日').format(selectedDay),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'お茶の記録: ${events.length}回',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'カフェイン: ${totalCaffeine}mg',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (events.isEmpty)
            const Center(child: Text('この日は記録がありません'))
          else
            ...events.map(
              (teaLog) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTeaTypeColor(teaLog.teaType),
                    child: Text(
                      teaLog.teaType[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('${teaLog.teaType}茶'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${teaLog.amount}ml • ${teaLog.caffeineMg}mg • ${teaLog.mood}',
                      ),
                      if (teaLog.notes != null)
                        Text(
                          teaLog.notes!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: Text(
                    DateFormat('HH:mm').format(teaLog.dateTime),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () => _showTeaLogDetail(teaLog),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getTeaTypeColor(String teaType) {
    switch (teaType) {
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.brown;
      case 'oolong':
        return Colors.orange;
      case 'herbal':
        return Colors.purple;
      case 'white':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showTeaLogDetail(TeaLog teaLog) {
    showDialog(
      context: context,
      builder: (context) => TeaLogDetailDialog(teaLog: teaLog),
    );
  }
}
