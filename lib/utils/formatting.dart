// lib/utils/formatting.dart

import 'package:flutter/services.dart';

String formatThousands(int value) {
  final isNegative = value < 0;
  final digits = value.abs().toString();
  final buf = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(' ');
    buf.write(digits[i]);
  }

  return isNegative ? '−${buf.toString()}' : buf.toString();
}

int? parseThousands(String text) {
  final cleaned = text.replaceAll(RegExp(r'[\s\u00A0]'), '');
  if (cleaned.isEmpty) return null;
  return int.tryParse(cleaned);
}

class ThousandsSeparatorFormatter extends TextInputFormatter {
  const ThousandsSeparatorFormatter({this.maxDigits = 8});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue();

    final limited =
        digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;

    final formatted = formatThousands(int.parse(limited));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Форматирует DateTime как дату без времени: yyyy-MM-dd.
/// 2025-10-06 14:32:11 → '2025-10-06'
String formatDateOnly(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Парсит дату из БД. Поддерживает оба формата:
/// 'yyyy-MM-dd' и старый 'yyyy-MM-ddTHH:mm:ss.sss'.
/// Всегда возвращает DateTime с обнулённым временем.
DateTime? parseDateOnly(String? value) {
  if (value == null || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// Приводит DateTime к началу суток (локальное время).
DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Названия месяцев в именительном падеже — для формата «октябрь 2026».
const List<String> monthNamesRu = [
  'январь',
  'февраль',
  'март',
  'апрель',
  'май',
  'июнь',
  'июль',
  'август',
  'сентябрь',
  'октябрь',
  'ноябрь',
  'декабрь',
];

/// Короткие названия месяцев — для формата «окт 2026».
const List<String> monthNamesRuShort = [
  'янв',
  'фев',
  'мар',
  'апр',
  'май',
  'июн',
  'июл',
  'авг',
  'сен',
  'окт',
  'ноя',
  'дек',
];

/// Формат «октябрь 2026» — для карточек ТО и истории, где важен только месяц.
String formatMonthYear(DateTime date) {
  return '${monthNamesRu[date.month - 1]} ${date.year}';
}

/// Короткий формат «окт 2026» — для компактных подписей.
String formatMonthYearShort(DateTime date) {
  return '${monthNamesRuShort[date.month - 1]} ${date.year}';
}

/// Склонение слова «работа» после числительного (именительный падеж).
String pluralWorks(int n) {
  if (n % 10 == 1 && n % 100 != 11) return 'работа';
  if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
    return 'работы';
  }
  return 'работ';
}

/// Склонение слова «работа» в винительном падеже
/// (для конструкций «Выполнить N …»).
String pluralWorksAccusative(int n) {
  if (n % 10 == 1 && n % 100 != 11) return 'работу';
  if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
    return 'работы';
  }
  return 'работ';
}
