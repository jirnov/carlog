// lib/data/models/history_record.dart

import 'package:carlog/utils/formatting.dart';

class HistoryRecord {
  const HistoryRecord({
    this.id,
    required this.title,
    this.note = '',
    required this.mileage,
    required this.performedAt,
    this.cost,
  });

  final int? id;
  final String title;
  final String note;
  final int mileage;
  final DateTime performedAt;
  final double? cost;

  factory HistoryRecord.fromMap(Map<String, Object?> map) {
    return HistoryRecord(
      id: map['id'] as int?,
      title: (map['title'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      mileage: (map['mileage'] as int?) ?? 0,
      performedAt: parseDateOnly(map['performed_at'] as String?) ??
          dateOnly(DateTime.now()),
      cost: (map['cost'] as num?)?.toDouble(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'note': note,
      'mileage': mileage,
      'performed_at': formatDateOnly(performedAt),
      'cost': cost,
    };
  }

  bool get hasCost => cost != null && cost! > 0;

  @override
  String toString() => 'HistoryRecord(id: $id, title: $title, '
      'mileage: $mileage, performedAt: ${formatDateOnly(performedAt)}, '
      'cost: $cost)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryRecord &&
        other.id == id &&
        other.title == title &&
        other.note == note &&
        other.mileage == mileage &&
        other.performedAt == performedAt &&
        other.cost == cost;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        note,
        mileage,
        performedAt,
        cost,
      );
}
