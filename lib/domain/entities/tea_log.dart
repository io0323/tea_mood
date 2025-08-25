import 'package:hive/hive.dart';

part 'tea_log.g.dart';

@HiveType(typeId: 0)
class TeaLog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String teaType; // "green", "black", "oolong", "herbal", etc.

  @HiveField(2)
  final int caffeineMg;

  @HiveField(3)
  final int temperature; // Celsius

  @HiveField(4)
  final DateTime dateTime;

  @HiveField(5)
  final String mood; // "relaxed", "focused", "energized", "calm", etc.

  @HiveField(6)
  final int amount; // ml

  @HiveField(7)
  final String? notes;

  TeaLog({
    required this.id,
    required this.teaType,
    required this.caffeineMg,
    required this.temperature,
    required this.dateTime,
    required this.mood,
    required this.amount,
    this.notes,
  });

  TeaLog copyWith({
    String? id,
    String? teaType,
    int? caffeineMg,
    int? temperature,
    DateTime? dateTime,
    String? mood,
    int? amount,
    String? notes,
  }) {
    return TeaLog(
      id: id ?? this.id,
      teaType: teaType ?? this.teaType,
      caffeineMg: caffeineMg ?? this.caffeineMg,
      temperature: temperature ?? this.temperature,
      dateTime: dateTime ?? this.dateTime,
      mood: mood ?? this.mood,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeaLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TeaLog(id: $id, teaType: $teaType, caffeineMg: $caffeineMg, temperature: $temperature, dateTime: $dateTime, mood: $mood, amount: $amount, notes: $notes)';
  }
} 