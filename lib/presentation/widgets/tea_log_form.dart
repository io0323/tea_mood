import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/tea_log.dart';
import '../providers/tea_log_providers.dart';

class TeaLogForm extends ConsumerStatefulWidget {
  final TeaLog? teaLog;

  const TeaLogForm({super.key, this.teaLog});

  @override
  ConsumerState<TeaLogForm> createState() => _TeaLogFormState();
}

class _TeaLogFormState extends ConsumerState<TeaLogForm> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedTeaType;
  late int _selectedAmount;
  late int _temperature;
  late String _selectedMood;
  late DateTime _selectedDateTime;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTeaType = widget.teaLog?.teaType ?? AppConstants.teaTypes.first;
    _selectedAmount =
        widget.teaLog?.amount ?? AppConstants.defaultAmounts.first;
    _temperature =
        widget.teaLog?.temperature ??
        AppConstants.defaultTemperatures[_selectedTeaType] ??
        70;
    _selectedMood = widget.teaLog?.mood ?? AppConstants.moods.first;
    _selectedDateTime = widget.teaLog?.dateTime ?? DateTime.now();
    _notesController.text = widget.teaLog?.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.teaLog == null ? 'お茶を記録' : '記録を編集',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Tea Type Selection
                    DropdownButtonFormField<String>(
                      value: _selectedTeaType,
                      decoration: const InputDecoration(
                        labelText: 'お茶の種類',
                        border: OutlineInputBorder(),
                      ),
                      items: AppConstants.teaTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text('${type}茶'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTeaType = value!;
                          _temperature =
                              AppConstants.defaultTemperatures[value] ?? 70;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Amount Selection
                    DropdownButtonFormField<int>(
                      value: _selectedAmount,
                      decoration: const InputDecoration(
                        labelText: '量 (ml)',
                        border: OutlineInputBorder(),
                      ),
                      items: AppConstants.defaultAmounts.map((amount) {
                        return DropdownMenuItem(
                          value: amount,
                          child: Text('${amount}ml'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAmount = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Temperature Slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('温度: ${_temperature}°C'),
                        Slider(
                          value: _temperature.toDouble(),
                          min: 50,
                          max: 100,
                          divisions: 50,
                          label: '${_temperature}°C',
                          onChanged: (value) {
                            setState(() {
                              _temperature = value.round();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mood Selection
                    DropdownButtonFormField<String>(
                      value: _selectedMood,
                      decoration: const InputDecoration(
                        labelText: '気分',
                        border: OutlineInputBorder(),
                      ),
                      items: AppConstants.moods.map((mood) {
                        return DropdownMenuItem(
                          value: mood,
                          child: Text(_getMoodDisplayName(mood)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMood = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // DateTime Picker
                    ListTile(
                      title: const Text('日時'),
                      subtitle: Text(
                        '${_selectedDateTime.year}/${_selectedDateTime.month.toString().padLeft(2, '0')}/${_selectedDateTime.day.toString().padLeft(2, '0')} ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDateTime,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 30),
                          ),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (!mounted) return;
                        if (date == null) return;
                        
                        if (!mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            _selectedDateTime,
                          ),
                        );
                        // Combined mounted check and setState immediately after showTimePicker
                        if (!mounted) return;
                        if (time != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'メモ',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Caffeine Info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'カフェイン量: ${_calculateCaffeine()}mg',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value:
                                  _calculateCaffeine() /
                                  400, // 400mg is daily limit
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _calculateCaffeine() > 400
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '1日の推奨上限: 400mg',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          // Fixed Action Buttons at bottom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('キャンセル'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTeaLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.teaLog == null ? '保存' : '更新',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  int _calculateCaffeine() {
    final baseCaffeine =
        AppConstants.defaultCaffeineContent[_selectedTeaType] ?? 0;
    return (baseCaffeine * _selectedAmount / 100).round();
  }

  void _saveTeaLog() {
    if (_formKey.currentState!.validate()) {
      final teaLog = TeaLog(
        id:
            widget.teaLog?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        teaType: _selectedTeaType,
        caffeineMg: _calculateCaffeine(),
        temperature: _temperature,
        dateTime: _selectedDateTime,
        mood: _selectedMood,
        amount: _selectedAmount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (widget.teaLog == null) {
        ref.read(teaLogNotifierProvider.notifier).addTeaLog(teaLog);
      } else {
        ref.read(teaLogNotifierProvider.notifier).updateTeaLog(teaLog);
      }

      Navigator.pop(context);
    }
  }
}
