// lib/data/models/history_record.dart

import 'package:carlog/utils/formatting.dart';

/// Запись о выполненной работе. Соответствует строке в таблице history.
class HistoryRecord {
  const HistoryRecord({
    this.id,
    this.ruleId,
    required this.title,
    this.note = '',
    required this.mileage,
    required this.performedAt,
    this.cost,
  });

  /// null — запись ещё не вставлена в БД.
  final int? id;

  /// Ссылка на правило. null — свободная работа, не привязанная к регламенту.
  /// При удалении правила становится null (ON DELETE SET NULL).
  final int? ruleId;

  /// Название работы — копия на момент выполнения.
  /// Хранится отдельно, чтобы запись не потеряла смысл при удалении правила.
  final String title;

  /// Заметка — копия на момент выполнения.
  final String note;

  /// Пробег на момент выполнения.
  final int mileage;

  /// Дата выполнения. В БД хранится в ISO-8601.
  final DateTime performedAt;

  /// Стоимость. null — не указана.
  final double? cost;

  /// Создать из строки БД.
  factory HistoryRecord.fromMap(Map<String, Object?> map) {
    return HistoryRecord(
      id: map['id'] as int?,
      ruleId: map['rule_id'] as int?,
      title: (map['title'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      mileage: (map['mileage'] as int?) ?? 0,
      performedAt: _parseDate(map['performed_at'] as String?) ?? DateTime.now(),
      cost: (map['cost'] as num?)?.toDouble(),
    );
  }

  /// Преобразовать в Map для записи в БД.
  /// Если id == null — не включаем его, чтобы SQLite сгенерировал сам.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'rule_id': ruleId,
      'title': title,
      'note': note,
      'mileage': mileage,
      'performed_at': performedAt.toIso8601String(),
      'cost': cost,
    };
  }

  /// Копия с изменёнными полями.
  HistoryRecord copyWith({
    int? id,
    int? ruleId,
    String? title,
    String? note,
    int? mileage,
    DateTime? performedAt,
    double? cost,
  }) {
    return HistoryRecord(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      title: title ?? this.title,
      note: note ?? this.note,
      mileage: mileage ?? this.mileage,
      performedAt: performedAt ?? this.performedAt,
      cost: cost ?? this.cost,
    );
  }

  /// Свободная работа — не привязана к правилу.
  bool get isFree => ruleId == null;

  /// Есть ли стоимость.
  bool get hasCost => cost != null && cost! > 0;

  /// Короткая подпись пробега — «287 450 км».
  String get mileageLabel => '${formatThousands(mileage)} км';

  /// Подпись стоимости — «4 500 ₽» или пустая строка.
  String get costLabel => hasCost ? '${formatThousands(cost!.round())} ₽' : '';

  @override
  String toString() {
    return 'HistoryRecord(id: $id, ruleId: $ruleId, title: $title, '
        'mileage: $mileage, performedAt: ${performedAt.toIso8601String()}, '
        'cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryRecord &&
        other.id == id &&
        other.ruleId == ruleId &&
        other.title == title &&
        other.note == note &&
        other.mileage == mileage &&
        other.performedAt == performedAt &&
        other.cost == cost;
  }

  @override
  int get hashCode => Object.hash(
        id,
        ruleId,
        title,
        note,
        mileage,
        performedAt,
        cost,
      );

  // --- Вспомогательные ---

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}