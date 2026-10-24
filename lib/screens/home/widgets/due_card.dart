// lib/screens/home/widgets/due_card.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/app_localizations.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/services/maintenance_service.dart';
import 'package:carlog/utils/formatting.dart';
import 'package:carlog/utils/rounding.dart';

class DueCard extends StatelessWidget {
  const DueCard({
    super.key,
    required this.due,
    required this.onMarkDone,
    required this.onPostpone,
    this.highlighted = false,
    this.selectionMode = false,
    this.selected = false,
    this.onLongPress,
    this.onTapInSelection,
  });

  final DueInfo due;
  final VoidCallback onMarkDone;
  final VoidCallback onPostpone;

  /// Подсветить карточку после выполнения работы.
  final bool highlighted;

  /// Режим выбора (мультивыбор).
  final bool selectionMode;

  /// Выбрана ли карточка (в режиме выбора).
  final bool selected;

  /// Long-press — вход в режим выбора.
  final VoidCallback? onLongPress;

  /// Тап в режиме выбора — переключить выбор.
  final VoidCallback? onTapInSelection;

  Color _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (due.isPostponed) {
      return scheme.outlineVariant;
    }
    switch (due.status) {
      case DueStatus.overdue:
        return scheme.error;
      case DueStatus.soon:
        return Colors.orange.shade600;
      case DueStatus.ok:
        return Colors.green.shade600;
    }
  }

  String _formatDayMonthYear(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _daysShort(int value, AppLocalizations l10n) {
    final abs = value.abs();
    if (abs < 30) return l10n.dayShort(count: abs);
    return l10n.dayShort(count: (abs / 30).round());
  }

  String _intervalText(AppLocalizations l10n, String locale) {
    final kmOverdue = due.kmLeft != null && due.kmLeft! < 0;
    final dateOverdue = due.daysLeft != null && due.daysLeft! < 0;

    if (kmOverdue || dateOverdue) {
      final parts = <String>[];
      if (kmOverdue) {
        parts.add(
          l10n.dueCardOverdueKm(
            km: formatThousands(roundKmDown(due.missedKm), locale),
          ),
        );
      }
      if (dateOverdue) {
        parts.add(
          l10n.dueCardOverdueDays(value: _daysShort(-due.daysLeft!, l10n)),
        );
      }
      return parts.join(' · ');
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
      parts.add(_daysShort(due.daysLeft!, l10n));
    }
    return parts.join(' · ');
  }

  String _nextText(AppLocalizations l10n, String locale) {
    final parts = <String>[];
    if (due.nextKm != null) {
      parts.add(
        l10n.kmWithValue(km: formatThousands(due.nextKm!, locale)),
      );
    }
    if (due.nextDate != null) {
      parts.add(formatMonthYear(due.nextDate!, locale));
    }
    return parts.join(' · ');
  }

  bool get _showPostpone => !due.isPostponed && due.status != DueStatus.ok;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final color = _statusColor(context);

    final isPostponed = due.isPostponed;
    final hasAnyOverdue = (due.kmLeft != null && due.kmLeft! < 0) ||
        (due.daysLeft != null && due.daysLeft! < 0);

    return Stack(
      children: [
        Card(
          child: InkWell(
            onLongPress: onLongPress,
            onTap: selectionMode ? onTapInSelection : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: color, width: 8),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectionMode) ...[
                        Checkbox(
                          value: selected,
                          onChanged: (_) => onTapInSelection?.call(),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              due.rule.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isPostponed
                                    ? theme.colorScheme.onSurfaceVariant
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (isPostponed) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.dueCardPostponedUntil(
                                      date: _formatDayMonthYear(
                                        due.postponement!.untilDate,
                                      ),
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              l10n.dueCardNext(
                                value: _nextText(l10n, locale),
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasAnyOverdue
                                  ? _intervalText(l10n, locale)
                                  : l10n.dueCardLeft(
                                      value: _intervalText(l10n, locale),
                                    ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: hasAnyOverdue && !isPostponed
                                    ? color
                                    : null,
                                fontWeight: hasAnyOverdue && !isPostponed
                                    ? FontWeight.w600
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!selectionMode) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_showPostpone) ...[
                          _ActionButton(
                            label: l10n.dueCardActionPostpone,
                            onPressed: onPostpone,
                          ),
                          const SizedBox(width: 8),
                        ],
                        _ActionButton(
                          label: l10n.dueCardActionMarkDone,
                          onPressed: onMarkDone,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (highlighted && !selectionMode)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: highlighted ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}
