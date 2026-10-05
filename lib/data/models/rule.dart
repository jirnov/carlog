// lib/data/models/rule.dart

/// Режим точки отсчёта правила.
enum BaseMode {
  /// С текущего момента — при создании подставляется текущий пробег и дата.
  auto,

  /// Указать вручную — пользователь задаёт точку отсчёта сам.
  manual;

  static BaseMode fromString(String value) {
    return BaseMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => BaseMode.auto,
    );
  }
}

/// Правило ТО. Соответствует строке в таблице rules.
class Rule {
  const Rule({
    this.id,
    required this.title,
    this.note = '',
    this.intervalKm,
    this.intervalMonths,
    this.baseKm,
    this.baseDate,
    this.baseMode = BaseMode.auto,
  });

  /// null — правило ещё не вставлено в БД.
  final int? id;
  final String title;
  final String note;

  /// Хотя бы один из двух интервалов должен быть задан.
  final int? intervalKm;
  final int? intervalMonths;

  /// Начальная точка — пробег. Обязателен при baseMode = manual.
  final int? baseKm;

  /// Начальная точка — дата. Обязательна при baseMode = manual
  /// и заданном intervalMonths.
  final DateTime? baseDate;

  final BaseMode baseMode;

  /// Создать из строки БД.
  factory Rule.fromMap(Map<String, Object?> map) {
    return Rule(
      id: map['id'] as int?,
      title: (map['title'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      intervalKm: map['interval_km'] as int?,
      intervalMonths: map['interval_months'] as int?,
      baseKm: map['base_km'] as int?,
      baseDate: _parseDate(map['base_date'] as String?),
      baseMode: BaseMode.fromString((map['base_mode'] as String?) ?? 'auto'),
    );
  }

  /// Преобразовать в Map для записи в БД.
  /// Если id == null — не включаем его, чтобы SQLite сгенерировал сам.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'note': note,
      'interval_km': intervalKm,
      'interval_months': intervalMonths,
      'base_km': baseKm,
      'base_date': _formatDate(baseDate),
      'base_mode': baseMode.name,
    };
  }

  /// Копия с изменёнными полями.
  Rule copyWith({
    int? id,
    String? title,
    String? note,
    int? intervalKm,
    int? intervalMonths,
    int? baseKm,
    DateTime? baseDate,
    BaseMode? baseMode,
  }) {
    return Rule(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      intervalKm: intervalKm ?? this.intervalKm,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      baseKm: baseKm ?? this.baseKm,
      baseDate: baseDate ?? this.baseDate,
      baseMode: baseMode ?? this.baseMode,
    );
  }

  /// Есть ли хотя бы один интервал — обязательное условие правила.
  bool get hasInterval =>
      (intervalKm != null && intervalKm! > 0) ||
      (intervalMonths != null && intervalMonths! > 0);

  /// Только по км.
  bool get isKmOnly => intervalKm != null && intervalKm! > 0 &&
      (intervalMonths == null || intervalMonths == 0);

  /// Только по времени.
  bool get isTimeOnly => intervalMonths != null && intervalMonths! > 0 &&
      (intervalKm == null || intervalKm == 0);

  /// По обоим интервалам — что наступит раньше.
  bool get isBoth => intervalKm != null && intervalKm! > 0 &&
      intervalMonths != null && intervalMonths! > 0;

  /// Человекочитаемая подпись интервала — для карточки.
  /// Например: «каждые 10 000 км», «каждые 12 мес», «каждые 10 000 км / 12 мес».
  String get intervalLabel {
    final parts = <String>[];
    if (intervalKm != null && intervalKm! > 0) {
      parts.add('каждые ${_formatNumber(intervalKm!)} км');
    }
    if (intervalMonths != null && intervalMonths! > 0) {
      parts.add('${intervalMonths} мес');
    }
    if (parts.length == 2) {
      return '${parts[0]} или ${parts[1]}';
    }
    return parts.isEmpty ? 'интервал не задан' : parts.first;
  }

  @override
  String toString() {
    return 'Rule(id: $id, title: $title, intervalKm: $intervalKm, '
        'intervalMonths: $intervalMonths, baseMode: $baseMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rule &&
        other.id == id &&
        other.title == title &&
        other.note == note &&
        other.intervalKm == intervalKm &&
        other.intervalMonths == intervalMonths &&
        other.baseKm == baseKm &&
        other.baseDate == baseDate &&
        other.baseMode == baseMode;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        note,
        intervalKm,
        intervalMonths,
        baseKm,
        baseDate,
        baseMode,
      );

  // --- Вспомогательные ---

  /// Парсит ISO-8601 дату из БД. Возвращает null, если строка null или пустая.
  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Форматирует дату в ISO-8601 для БД.
  static String? _formatDate(DateTime? date) {
    return date?.toIso8601String();
  }

  /// Простое форматирование числа с пробелами — 10000 → «10 000».
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