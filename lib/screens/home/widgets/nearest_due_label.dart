// lib/screens/home/widgets/nearest_due_label.dart

import 'package:flutter/material.dart';

import 'package:carlog/services/maintenance_service.dart';
import 'package:carlog/utils/formatting.dart';
import 'package:carlog/utils/rounding.dart';

class NearestDueLabel extends StatelessWidget {
  const NearestDueLabel({super.key, required this.due});

  final DueInfo due;

  /// Строка статуса.
  ///
  /// Если что-то просрочено — показываем **только просроченные параметры**.
  /// Иначе — остатки.
  String _formatInterval() {
    final kmOverdue = due.kmLeft != null && due.kmLeft! < 0;
    final dateOverdue = due.daysLeft != null && due.daysLeft! < 0;

    if (kmOverdue || dateOverdue) {
      final parts = <String>[];
      if (kmOverdue) {
        parts.add('${formatThousands(roundKmDown(due.missedKm))} км');
      }
      if (dateOverdue) {
        parts.add(formatDaysLeft(-due.daysLeft!));
      }
      return parts.join(' / ');
    }

    final parts = <String>[];
    if (due.kmLeft != null) {
      parts.add('${formatThousands(roundKmDown(due.kmLeft!))} км');
    }
    if (due.daysLeft != null) {
      parts.add(formatDaysLeft(due.daysLeft!));
    }
    return parts.join(' / ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = due.status == DueStatus.overdue;

    final color = isOverdue
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    final text = isOverdue
        ? 'Просрочено: ${_formatInterval()}'
        : 'Ближайшее ТО через ${_formatInterval()}';

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
