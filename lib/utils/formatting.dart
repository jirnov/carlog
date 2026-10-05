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

    final limited = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;

    final formatted = formatThousands(int.parse(limited));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}