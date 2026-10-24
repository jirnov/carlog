// lib/screens/history/widgets/history_card.dart

import 'package:flutter/material.dart';

import 'package:carlog/data/models/history_record.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/utils/formatting.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
  });

  final HistoryRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final subtleColor = theme.colorScheme.onSurfaceVariant;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (record.note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        record.note,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: subtleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          l10n.historyCardMileage(
                            km: formatThousands(record.mileage),
                          ),
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          ' · ${formatMonthYear(record.performedAt)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: subtleColor,
                          ),
                        ),
                      ],
                    ),
                    if (record.hasCost) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.historyCardCost(
                          amount: formatThousands(record.cost!.round()),
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: theme.colorScheme.primary,
                onPressed: onTap,
                tooltip: l10n.historyCardEditTooltip,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                onPressed: onDelete,
                tooltip: l10n.historyCardDeleteTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
