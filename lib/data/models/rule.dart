// lib/data/models/rule.dart

import 'package:carlog/utils/formatting.dart';

class Rule {
  const Rule({
    this.id,
    required this.title,
    this.note = '',
    this.nextKm,
    this.nextDate,
    this.intervalKm,
    this.intervalMonths,
    this.cost,
  });

  final int? id;
  final String title;
  final String note;

  /// Пробег следующего ТО. null — если интервала по км нет.
  final int? nextKm;

  /// Месяц следующего ТО. null — если интервала по месяцам нет.
  final DateTime? nextDate;

  /// Интервал по км. null — если не задан.
  final int? intervalKm;

  /// Интервал по месяцам. null — если не задан.
  final int? intervalMonths;

  /// Примерная стоимость работы. null — если не задана.
  final double? cost;

  factory Rule.fromMap(Map<String, Object?> map) {
    return Rule(
      id: map['id'] as int?,
      title: (map['title'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      nextKm: map['next_km'] as int?,
      nextDate: parseDateOnly(map['next_date'] as String?),
      intervalKm: map['interval_km'] as int?,
      intervalMonths: map['interval_months'] as int?,
      cost: (map['cost'] as num?)?.toDouble(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'note': note,
      'next_km': nextKm,
      'next_date': nextDate != null ? formatDateOnly(nextDate!) : null,
      'interval_km': intervalKm,
      'interval_months': intervalMonths,
      'cost': cost,
    };
  }

  Rule copyWith({
    int? id,
    String? title,
    String? note,
    int? nextKm,
    DateTime? nextDate,
    int? intervalKm,
    int? intervalMonths,
    double? cost,
  }) {
    return Rule(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      nextKm: nextKm ?? this.nextKm,
      nextDate: nextDate ?? this.nextDate,
      intervalKm: intervalKm ?? this.intervalKm,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      cost: cost ?? this.cost,
    );
  }

  bool get hasInterval =>
      (intervalKm != null && intervalKm! > 0) ||
      (intervalMonths != null && intervalMonths! > 0);

  @override
  String toString() =>
      'Rule(id: $id, title: $title, nextKm: $nextKm, nextDate: $nextDate, '
      'intervalKm: $intervalKm, intervalMonths: $intervalMonths, '
      'cost: $cost)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rule &&
        other.id == id &&
        other.title == title &&
        other.note == note &&
        other.nextKm == nextKm &&
        other.nextDate == nextDate &&
        other.intervalKm == intervalKm &&
        other.intervalMonths == intervalMonths &&
        other.cost == cost;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        note,
        nextKm,
        nextDate,
        intervalKm,
        intervalMonths,
        cost,
      );
}
