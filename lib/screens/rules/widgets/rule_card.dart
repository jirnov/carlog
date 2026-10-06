// lib/screens/rules/widgets/rule_card.dart

import 'package:flutter/material.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/utils/formatting.dart';

class RuleCard extends StatelessWidget {
  const RuleCard({
    super.key,
    required this.rule,
    required this.onTap,
    required this.onDelete,
  });

  final Rule rule;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  String _intervalLabel() {
    final parts = <String>[];
    if (rule.intervalKm != null && rule.intervalKm! > 0) {
      parts.add('${formatThousands(rule.intervalKm!)} км');
    }
    if (rule.intervalMonths != null && rule.intervalMonths! > 0) {
      parts.add('${rule.intervalMonths} мес');
    }
    if (parts.isEmpty) return 'интервал не задан';
    if (parts.length == 1) return 'Каждые ${parts.first}';
    return 'Каждые ${parts[0]} или ${parts[1]}';
  }

  String _nextLabel() {
    final kmText =
        rule.nextKm != null ? '${formatThousands(rule.nextKm!)} км' : null;

    final dateText =
        rule.nextDate != null ? formatMonthYearShort(rule.nextDate!) : null;

    if (kmText != null && dateText == null) {
      return 'Следующее: $kmText';
    }
    if (dateText != null && kmText == null) {
      return 'Следующее: $dateText';
    }
    if (kmText != null && dateText != null) {
      return 'Следующее: $kmText · $dateText';
    }
    return 'Следующее ТО не задано';
  }

  /// «~5 000 ₽» или null, если стоимость не задана.
  String? _costLabel() {
    final cost = rule.cost;
    if (cost == null || cost <= 0) return null;
    return '~${formatThousands(cost.round())} ₽';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final costLabel = _costLabel();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _intervalLabel(),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _nextLabel(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (costLabel != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        costLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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
                tooltip: 'Редактировать',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                onPressed: onDelete,
                tooltip: 'Удалить',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
