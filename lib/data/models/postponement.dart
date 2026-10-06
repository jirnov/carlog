// lib/data/models/postponement.dart

import 'package:carlog/utils/formatting.dart';

/// Отложка ТО для правила.
/// Одна активная отложка на правило.
class Postponement {
  const Postponement({
    required this.ruleId,
    required this.untilDate,
    required this.createdAt,
  });

  final int ruleId;
  final DateTime untilDate;
  final DateTime createdAt;

  /// Активна ли отложка на указанную дату.
  bool isActiveAt(DateTime date) {
    final today = dateOnly(date);
    final until = dateOnly(untilDate);
    return until.isAfter(today) || until.isAtSameMomentAs(today);
  }

  /// Просрочена ли отложка (дата прошла, но запись ещё есть).
  bool isExpiredAt(DateTime date) {
    final today = dateOnly(date);
    final until = dateOnly(untilDate);
    return until.isBefore(today);
  }

  factory Postponement.fromMap(Map<String, Object?> map) {
    return Postponement(
      ruleId: map['rule_id'] as int,
      untilDate: parseDateOnly(map['until_date'] as String?) ??
          dateOnly(DateTime.now()),
      createdAt: parseDateOnly(map['created_at'] as String?) ??
          dateOnly(DateTime.now()),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'rule_id': ruleId,
      'until_date': formatDateOnly(untilDate),
      'created_at': formatDateOnly(createdAt),
    };
  }

  @override
  String toString() => 'Postponement(ruleId: $ruleId, '
      'untilDate: ${formatDateOnly(untilDate)}, '
      'createdAt: ${formatDateOnly(createdAt)})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Postponement &&
        other.ruleId == ruleId &&
        other.untilDate == untilDate &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(ruleId, untilDate, createdAt);
}
