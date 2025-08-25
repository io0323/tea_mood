import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/tea_log.dart';
import '../providers/tea_log_providers.dart';
import 'tea_log_form.dart';

class TeaLogDetailDialog extends ConsumerWidget {
  final TeaLog teaLog;

  const TeaLogDetailDialog({super.key, required this.teaLog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getTeaTypeColor(teaLog.teaType),
                  child: Text(
                    teaLog.teaType[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${teaLog.teaType}茶',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        DateFormat('yyyy年M月d日 HH:mm').format(teaLog.dateTime),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Details
            _buildDetailRow('量', '${teaLog.amount}ml'),
            _buildDetailRow('温度', '${teaLog.temperature}°C'),
            _buildDetailRow('カフェイン', '${teaLog.caffeineMg}mg'),
            _buildDetailRow('気分', _getMoodDisplayName(teaLog.mood)),
            
            if (teaLog.notes != null) ...[
              const SizedBox(height: 16),
              Text(
                'メモ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(teaLog.notes!),
            ],
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditDialog(context);
                    },
                    child: const Text('編集'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _deleteTeaLog(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('削除'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
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

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => TeaLogForm(teaLog: teaLog),
      ),
    );
  }

  void _deleteTeaLog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: const Text('この記録を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(teaLogNotifierProvider.notifier).deleteTeaLog(teaLog.id);
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close detail dialog
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
} 