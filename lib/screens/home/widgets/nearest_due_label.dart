// lib/screens/home/widgets/nearest_due_label.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/app_localizations.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/services/maintenance_service.dart';
import 'package:carlog/utils/formatting.dart';
import 'package:carlog/utils/rounding.dart';

class NearestDueLabel extends StatelessWidget {
  const NearestDueLabel({super.key, required this.due});

  final DueInfo due;

  String _daysLabel(int value, AppLocalizations l10n) {
    final abs = value.abs();
    if (abs < 30) return l10n.dayShort(count: abs);
    return l10n.monthsWithValue(months: (abs / 30).round());
  }

  /// Строка статуса.
  ///
  /// Если что-то просрочено — показываем **только просроченные параметры**.
  /// Иначе — остатки.
  String _formatInterval(AppLocalizations l10n, String locale) {
    final kmOverdue = due.kmLeft != null && due.kmLeft! < 0;
    final dateOverdue = due.daysLeft != null && due.daysLeft! < 0;

    if (kmOverdue || dateOverdue) {
      final parts = <String>[];
      if (kmOverdue) {
        parts.add(
          l10n.kmWithValue(
            km: formatThousands(roundKmDown(due.missedKm), locale),
          ),
        );
      }
      if (dateOverdue) {
        parts.add(_daysLabel(-due.daysLeft!, l10n));
      }
      return parts.join(' / ');
    }

    final parts = <String>[];
    if (due.kmLeft != null) {
      parts.add(
        l10n.kmWithValue(
          km: formatThousands(roundKmDown(due.kmLeft!), locale),
        ),
      );
    }
    if (due.daysLeft != null) {
      parts.add(_daysLabel(due.daysLeft!, l10n));
    }
    return parts.join(' / ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final isOverdue = due.status == DueStatus.overdue;

    final color = isOverdue
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    final interval = _formatInterval(l10n, locale);
    final text = isOverdue
        ? l10n.nearestDueOverdue(value: interval)
        : l10n.nearestDueSoon(value: interval);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isOverdue) ...[
            Icon(
              Icons.warning_amber_rounded,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
