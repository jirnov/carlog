// lib/data/models/mileage_entry.dart

/// Запись в журнале пробега. Соответствует строке в таблице mileage_log.
class MileageEntry {
  const MileageEntry({
    this.id,
    required this.mileage,
    required this.recordedAt,
  });

  /// null — запись ещё не вставлена в БД.
  final int? id;

  /// Значение пробега на момент записи.
  final int mileage;

  /// Дата записи. В БД хранится в ISO-8601.
  final DateTime recordedAt;

  /// Создать из строки БД.
  factory MileageEntry.fromMap(Map<String, Object?> map) {
    return MileageEntry(
      id: map['id'] as int?,
      mileage: (map['mileage'] as int?) ?? 0,
      recordedAt: _parseDate(map['recorded_at'] as String?) ?? DateTime.now(),
    );
  }

  /// Преобразовать в Map для записи в БД.
  /// Если id == null — не включаем, чтобы SQLite сгенерировал сам.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'mileage': mileage,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  /// Копия с изменёнными полями.
  MileageEntry copyWith({
    int? id,
    int? mileage,
    DateTime? recordedAt,
  }) {
    return MileageEntry(
      id: id ?? this.id,
      mileage: mileage ?? this.mileage,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  /// Короткая подпись для отображения: «287 450 км».
  String get label => '${_formatNumber(mileage)} км';

  @override
  String toString() {
    return 'MileageEntry(id: $id, mileage: $mileage, '
        'recordedAt: ${recordedAt.toIso8601String()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MileageEntry &&
        other.id == id &&
        other.mileage == mileage &&
        other.recordedAt == recordedAt;
  }

  @override
  int get hashCode => Object.hash(id, mileage, recordedAt);

  // --- Вспомогательные ---

  /// Парсит ISO-8601 дату из БД. Возвращает null, если строка null или пустая.
  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Форматирование числа с пробелами: 287450 → «287 450».
  static String _formatNumber(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}