// lib/screens/home/widgets/mileage_header.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/context_l10n.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isStale = _isStale;

    // Оранжевый — если пора обновить. Иначе серый, как было.
    final subtitleColor =
        isStale ? Colors.orange.shade700 : theme.colorScheme.onSurfaceVariant;

    final String subtitle;
    if (lastUpdatedAt == null) {
      subtitle = l10n.mileageHeaderNotSet;
    } else {
      final days = _daysSinceUpdate!;
      if (days <= 0) {
        subtitle = l10n.mileageHeaderUpdatedToday;
      } else if (days == 1) {
        subtitle = l10n.mileageHeaderUpdatedYesterday;
      } else {
        subtitle = l10n.mileageHeaderUpdatedDaysAgo(days: days);
      }
    }

    final subtitleText =
        isStale ? '$subtitle · ${l10n.mileageHeaderStaleSuffix}' : subtitle;

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
                l10n.mileageHeaderUnitKm,
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
            label: Text(l10n.mileageHeaderUpdateButton),
          ),
        ],
      ),
    );
  }
}
