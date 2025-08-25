import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/tea_log.dart';
import '../providers/tea_log_providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _selectedPeriod = 7; // 7 days default

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day);
    final startDate = endDate.subtract(Duration(days: _selectedPeriod - 1));

    final analyticsAsync = ref.watch(
      teaLogsByDateRangeProvider((startDate: startDate, endDate: endDate)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('分析'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('7日間')),
              const PopupMenuItem(value: 14, child: Text('14日間')),
              const PopupMenuItem(value: 30, child: Text('30日間')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${_selectedPeriod}日間'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: analyticsAsync.when(
        data: (teaLogs) {
          // Calculate stats from teaLogs
          final moodStats = _calculateMoodStats(teaLogs);
          final teaTypeStats = _calculateTeaTypeStats(teaLogs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                _buildSummaryCards(teaLogs),
                const SizedBox(height: 24),

                // Caffeine Trend Chart
                _buildCaffeineTrendChart(teaLogs),
                const SizedBox(height: 24),

                // Mood Distribution Chart
                _buildMoodChart(moodStats),
                const SizedBox(height: 24),

                // Tea Type Distribution Chart
                _buildTeaTypeChart(teaTypeStats),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('エラー: $error')),
      ),
    );
  }

  Widget _buildSummaryCards(List<TeaLog> teaLogs) {
    final totalCaffeine = teaLogs.fold<int>(
      0,
      (sum, log) => sum + log.caffeineMg,
    );
    final totalTeaCount = teaLogs.length;
    final avgCaffeinePerDay = totalTeaCount > 0
        ? totalCaffeine / _selectedPeriod
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.local_cafe, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$totalTeaCount',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('お茶の回数', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.trending_up, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${totalCaffeine}mg',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('総カフェイン', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.calendar_today, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${avgCaffeinePerDay.round()}mg',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text('1日平均', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaffeineTrendChart(List<TeaLog> teaLogs) {
    final caffeineData = _prepareCaffeineData(teaLogs);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('カフェイン推移', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.round()}mg');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < caffeineData.length) {
                            return Text(
                              DateFormat(
                                'M/d',
                              ).format(caffeineData[value.toInt()].date),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: caffeineData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.caffeine.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodChart(Map<String, int> moodStats) {
    if (moodStats.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('気分データがありません'),
        ),
      );
    }

    final sections = moodStats.entries.map((entry) {
      final color = _getMoodColor(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${_getMoodDisplayName(entry.key)}\n${entry.value}回',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('気分の分布', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(sections: sections, centerSpaceRadius: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeaTypeChart(Map<String, int> teaTypeStats) {
    if (teaTypeStats.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('お茶の種類データがありません'),
        ),
      );
    }

    final sections = teaTypeStats.entries.map((entry) {
      final color = _getTeaTypeColor(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key}茶\n${entry.value}回',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('お茶の種類分布', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(sections: sections, centerSpaceRadius: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CaffeineDataPoint> _prepareCaffeineData(List<TeaLog> teaLogs) {
    final Map<DateTime, int> dailyCaffeine = {};

    // Initialize all days in the period
    for (int i = 0; i < _selectedPeriod; i++) {
      final date = DateTime.now().subtract(
        Duration(days: _selectedPeriod - 1 - i),
      );
      final dayStart = DateTime(date.year, date.month, date.day);
      dailyCaffeine[dayStart] = 0;
    }

    // Sum caffeine for each day
    for (final log in teaLogs) {
      final dayStart = DateTime(
        log.dateTime.year,
        log.dateTime.month,
        log.dateTime.day,
      );
      dailyCaffeine[dayStart] = (dailyCaffeine[dayStart] ?? 0) + log.caffeineMg;
    }

    return dailyCaffeine.entries
        .map((entry) => CaffeineDataPoint(entry.key, entry.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'relaxed':
        return Colors.green;
      case 'focused':
        return Colors.blue;
      case 'energized':
        return Colors.orange;
      case 'calm':
        return Colors.teal;
      case 'stressed':
        return Colors.red;
      case 'happy':
        return Colors.yellow;
      case 'tired':
        return Colors.grey;
      case 'alert':
        return Colors.purple;
      case 'peaceful':
        return Colors.lightBlue;
      case 'anxious':
        return Colors.pink;
      default:
        return Colors.grey;
    }
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

  String _getMoodDisplayName(String mood) {
    switch (mood) {
      case 'relaxed':
        return 'リラックス';
      case 'focused':
        return '集中';
      case 'energized':
        return '元気';
      case 'calm':
        return '落ち着き';
      case 'stressed':
        return 'ストレス';
      case 'happy':
        return '幸せ';
      case 'tired':
        return '疲れ';
      case 'alert':
        return '覚醒';
      case 'peaceful':
        return '平和';
      case 'anxious':
        return '不安';
      default:
        return mood;
    }
  }

  Map<String, int> _calculateMoodStats(List<TeaLog> teaLogs) {
    final moodStats = <String, int>{};
    for (final log in teaLogs) {
      moodStats[log.mood] = (moodStats[log.mood] ?? 0) + 1;
    }
    return moodStats;
  }

  Map<String, int> _calculateTeaTypeStats(List<TeaLog> teaLogs) {
    final teaTypeStats = <String, int>{};
    for (final log in teaLogs) {
      teaTypeStats[log.teaType] = (teaTypeStats[log.teaType] ?? 0) + 1;
    }
    return teaTypeStats;
  }
}

class CaffeineDataPoint {
  final DateTime date;
  final int caffeine;

  CaffeineDataPoint(this.date, this.caffeine);
}
