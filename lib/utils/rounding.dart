// lib/utils/rounding.dart

/// Округление остатка км вниз по правилам из ТЗ.
int roundKmDown(int value) {
  final v = value.abs();
  int rounded;
  if (v >= 10000) {
    rounded = (v ~/ 1000) * 1000;
  } else if (v >= 1000) {
    rounded = (v ~/ 500) * 500;
  } else if (v >= 100) {
    rounded = (v ~/ 50) * 50;
  } else if (v >= 10) {
    rounded = (v ~/ 10) * 10;
  } else {
    rounded = v;
  }
  return value < 0 ? -rounded : rounded;
}

/// Округление срока вниз. Возвращает человекочитаемую строку.
/// daysLeft — остаток в днях (может быть отрицательным).
String formatDaysLeft(int daysLeft) {
  final v = daysLeft.abs();
  final sign = daysLeft < 0 ? '−' : '';

  if (v == 0) return 'сегодня';
  if (v == 1) return '$signзавтра';

  if (v < 7) {
    return '$sign$v ${_pluralDays(v)}';
  }
  if (v < 30) {
    final weeks = v ~/ 7;
    return '$sign~$weeks ${_pluralWeeks(weeks)}';
  }
  final months = v ~/ 30;
  return '$sign~$months ${_pluralMonths(months)}';
}

/// Короткий формат срока для карточки на главном экране.
/// Не разворачивает в недели и дни — только месяцы или «меньше месяца».
///
/// - `daysLeft > 30` → `~N мес`;
/// - иначе (в т.ч. 0 и отрицательные) → `меньше месяца`.
String formatDaysLeftShort(int daysLeft) {
  if (daysLeft > 30) {
    final months = daysLeft ~/ 30;
    return '~$months ${_pluralMonths(months)}';
  }
  return 'меньше месяца';
}

String _pluralDays(int n) {
  if (n % 10 == 1 && n % 100 != 11) return 'день';
  if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
    return 'дня';
  }
  return 'дней';
}

String _pluralWeeks(int n) {
  if (n % 10 == 1 && n % 100 != 11) return 'неделя';
  if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
    return 'недели';
  }
  return 'недель';
}

String _pluralMonths(int n) {
  if (n % 10 == 1 && n % 100 != 11) return 'месяц';
  if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
    return 'месяца';
  }
  return 'месяцев';
}
