// lib/screens/rules/widgets/rule_card.dart

import 'package:flutter/material.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/l10n/context_l10n.dart';
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

  String _intervalLabel(BuildContext context) {
    final l10n = context.l10n;
    final parts = <String>[];
    if (rule.intervalKm != null && rule.intervalKm! > 0) {
      parts.add(l10n.ruleCardIntervalKm(km: formatThousands(rule.intervalKm!)));
    }
    if (rule.intervalMonths != null && rule.intervalMonths! > 0) {
      parts.add(l10n.ruleCardIntervalMonths(months: rule.intervalMonths!));
    }
    if (parts.isEmpty) return l10n.ruleCardIntervalNotSet;
    if (parts.length == 1) return l10n.ruleCardEveryOne(value: parts.first);
    return l10n.ruleCardEveryTwo(first: parts[0], second: parts[1]);
  }

  String _nextLabel(BuildContext context) {
    final l10n = context.l10n;

    final kmText = rule.nextKm != null
        ? l10n.ruleCardIntervalKm(km: formatThousands(rule.nextKm!))
        : null;

    final dateText =
        rule.nextDate != null ? formatMonthYearShort(rule.nextDate!) : null;

    if (kmText != null && dateText == null) {
      return l10n.ruleCardNextOne(value: kmText);
    }
    if (dateText != null && kmText == null) {
      return l10n.ruleCardNextOne(value: dateText);
    }
    if (kmText != null && dateText != null) {
      return l10n.ruleCardNextTwo(first: kmText, second: dateText);
    }
    return l10n.ruleCardNextNotSet;
  }

  /// «~5 000 ₽» или null, если стоимость не задана.
  String? _costLabel(BuildContext context) {
    final cost = rule.cost;
    if (cost == null || cost <= 0) return null;
    return context.l10n.ruleCardCost(amount: formatThousands(cost.round()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final costLabel = _costLabel(context);

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
                      _intervalLabel(context),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _nextLabel(context),
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
                tooltip: l10n.ruleCardEditTooltip,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                onPressed: onDelete,
                tooltip: l10n.ruleCardDeleteTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
