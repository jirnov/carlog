// lib/utils/rounding.dart

/// Округление остатка км вниз по правилам из ТЗ.
///
/// Пороги и шаги:
/// - ≥ 10 000 → до 1 000;
/// - ≥ 1 000  → до 500;
/// - ≥ 100    → до 50;
/// - ≥ 10     → до 10;
/// - < 10     → без округления.
///
/// Знак сохраняется: для отрицательного значения результат тоже
/// отрицательный. Ноль остаётся нулём.
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
