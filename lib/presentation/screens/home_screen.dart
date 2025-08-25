import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/tea_log.dart';
import '../providers/tea_log_providers.dart';
import '../widgets/tea_log_form.dart';
import 'calendar_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TeaLogEntryScreen(),
    const CalendarScreen(),
    const AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '記録'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
          NavigationDestination(icon: Icon(Icons.analytics), label: '分析'),
        ],
      ),
    );
  }
}

class TeaLogEntryScreen extends ConsumerStatefulWidget {
  const TeaLogEntryScreen({super.key});

  @override
  ConsumerState<TeaLogEntryScreen> createState() => _TeaLogEntryScreenState();
}

class _TeaLogEntryScreenState extends ConsumerState<TeaLogEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final teaLogsAsync = ref.watch(teaLogsProvider);
    final today = DateTime.now();
    final todayCaffeineAsync = ref.watch(
      totalCaffeineByDateProvider(DateTime(today.year, today.month, today.day)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('TeaMood'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今日のサマリー',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    todayCaffeineAsync.when(
                      data: (caffeine) => Text(
                        'カフェイン摂取量: ${caffeine}mg',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('エラー: $error'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => ref.refresh(
                              totalCaffeineByDateProvider(DateTime.now()),
                            ),
                            child: const Text('再試行'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recent Tea Logs
            Text('最近の記録', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),

            Expanded(
              child: teaLogsAsync.when(
                data: (teaLogs) => teaLogs.isEmpty
                    ? const Center(
                        child: Text('まだ記録がありません。\nお茶を飲んだら記録してみましょう！'),
                      )
                    : ListView.builder(
                        itemCount: teaLogs.take(5).length,
                        itemBuilder: (context, index) {
                          final teaLog = teaLogs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getTeaTypeColor(
                                  teaLog.teaType,
                                ),
                                child: Text(
                                  teaLog.teaType[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text('${teaLog.teaType}茶'),
                              subtitle: Text(
                                '${teaLog.amount}ml • ${teaLog.caffeineMg}mg • ${teaLog.mood}',
                              ),
                              trailing: Text(
                                _formatTime(teaLog.dateTime),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('エラー: $error')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTeaLogDialog(context),
        label: const Text('お茶を記録'),
        icon: const Icon(Icons.add),
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

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showAddTeaLogDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => const TeaLogForm(),
      ),
    );
  }
}
