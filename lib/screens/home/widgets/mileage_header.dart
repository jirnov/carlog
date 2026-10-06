// lib/screens/home/widgets/mileage_header.dart

import 'package:flutter/material.dart';

import 'package:carlog/utils/formatting.dart';

class MileageHeader extends StatelessWidget {
  const MileageHeader({
    super.key,
    required this.mileage,
    required this.lastUpdatedAt,
    required this.remindEnabled,
    required this.remindDays,
    required this.onUpdate,
  });

  final int mileage;
  final DateTime? lastUpdatedAt;
  final bool remindEnabled;
  final int remindDays;
  final VoidCallback onUpdate;

  /// Сколько календарных дней прошло с последнего обновления.
  int? get _daysSinceUpdate {
    if (lastUpdatedAt == null) return null;
    final today = dateOnly(DateTime.now());
    final updated = dateOnly(lastUpdatedAt!);
    return today.difference(updated).inDays;
  }

  /// Пора ли напомнить об обновлении.
  bool get _isStale {
    if (!remindEnabled) return false;
    final days = _daysSinceUpdate;
    if (days == null) return false;
    return days >= remindDays;
  }

  String get _subtitle {
    if (lastUpdatedAt == null) return 'Пробег не задан';
    final days = _daysSinceUpdate!;
    if (days <= 0) return 'Обновлено сегодня';
    if (days == 1) return 'Обновлено вчера';
    return 'Обновлено $days ${_pluralDays(days)} назад';
  }

  String _pluralDays(int n) {
    if (n % 10 == 1 && n % 100 != 11) return 'день';
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return 'дня';
    }
    return 'дней';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isStale = _isStale;

    // Оранжевый — если пора обновить. Иначе серый, как было.
    final subtitleColor =
        isStale ? Colors.orange.shade700 : theme.colorScheme.onSurfaceVariant;

    final subtitleText = isStale ? '$_subtitle · обновить' : _subtitle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatThousands(mileage),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'км',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Подпись. При устаревании — кликабельная, оранжевая.
          InkWell(
            onTap: isStale ? onUpdate : null,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isStale) ...[
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: subtitleColor,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    subtitleText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: subtitleColor,
                      fontWeight: isStale ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onUpdate,
            icon: const Icon(Icons.refresh),
            label: const Text('Обновить пробег'),
          ),
        ],
      ),
    );
  }
}
