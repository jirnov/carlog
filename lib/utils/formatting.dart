// lib/utils/formatting.dart

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatThousands(int value, String locale) {
  return NumberFormat.decimalPattern(locale).format(value);
}

/// Разбирает число, игнорируя любые разделители разрядов:
/// пробелы, неразрывные пробелы, запятые, точки.
int? parseThousands(String text) {
  final cleaned = text.replaceAll(RegExp(r'[^\d-]'), '');
  if (cleaned.isEmpty || cleaned == '-') return null;
  return int.tryParse(cleaned);
}

class ThousandsSeparatorFormatter extends TextInputFormatter {
  const ThousandsSeparatorFormatter({
    required this.locale,
    this.maxDigits = 8,
  });

  final String locale;
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

    final formatted = formatThousands(int.parse(limited), locale);

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

/// Формат «октябрь 2026» — для карточек ТО и истории, где важен только месяц.
String formatMonthYear(DateTime date, String locale) =>
    DateFormat('LLLL y', locale).format(date);

/// Короткий формат «окт 2026» — для компактных подписей.
String formatMonthYearShort(DateTime date, String locale) =>
    DateFormat('LLL y', locale).format(date);
