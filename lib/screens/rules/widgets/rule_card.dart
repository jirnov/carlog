// lib/screens/rules/widgets/rule_card.dart

import 'package:flutter/material.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/utils/formatting.dart';

class RuleCard extends StatelessWidget {
  const RuleCard({
    super.key,
    required this.rule,
    required this.expanded,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Rule rule;
  final bool expanded;

  /// Вызывается только при тапе по карточке.
  /// [canExpand] сообщает экрану, можно ли вообще разворачивать —
  /// экран игнорирует `false` (не сворачивает другую открытую карточку).
  final void Function(bool canExpand) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _animDuration = Duration(milliseconds: 240);
  static const _animCurve = Curves.easeInOutCubic;
  static const _collapsedMaxLines = 1;

  String _intervalLabel(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final parts = <String>[];
    if (rule.intervalKm != null && rule.intervalKm! > 0) {
      parts.add(
        l10n.kmWithValue(
          km: formatThousands(rule.intervalKm!, locale),
        ),
      );
    }
    if (rule.intervalMonths != null && rule.intervalMonths! > 0) {
      parts.add(l10n.monthsWithValue(months: rule.intervalMonths!));
    }
    if (parts.isEmpty) return l10n.intervalNotSet.toLowerCase();
    if (parts.length == 1) return l10n.ruleCardEveryOne(value: parts.first);
    return l10n.ruleCardEveryTwo(first: parts[0], second: parts[1]);
  }

  String _nextLabel(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    final kmText = rule.nextKm != null
        ? l10n.kmWithValue(
            km: formatThousands(rule.nextKm!, locale),
          )
        : null;

    final dateText = rule.nextDate != null
        ? formatMonthYearShort(rule.nextDate!, locale)
        : null;

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

  String? _costLabel(BuildContext context) {
    final cost = rule.cost;
    if (cost == null || cost <= 0) return null;
    final locale = Localizations.localeOf(context).languageCode;
    return context.l10n.ruleCardCost(
      amount: formatThousands(cost.round(), locale),
    );
  }

  bool _willOverflow(
    BuildContext context,
    String text,
    TextStyle? style,
    double maxWidth,
  ) {
    if (text.isEmpty) return false;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: _collapsedMaxLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final titleStyle = theme.textTheme.titleMedium;
    final intervalStyle = theme.textTheme.bodyMedium;
    final nextStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final costStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final costLabel = _costLabel(context);
    final intervalLabel = _intervalLabel(context);
    final nextLabel = _nextLabel(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;

                  final titleOverflows =
                      _willOverflow(context, rule.title, titleStyle, maxW);
                  final intervalOverflows = _willOverflow(
                      context, intervalLabel, intervalStyle, maxW);
                  final nextOverflows =
                      _willOverflow(context, nextLabel, nextStyle, maxW);
                  final costOverflows = costLabel != null &&
                      _willOverflow(context, costLabel, costStyle, maxW);

                  final canExpand = titleOverflows ||
                      intervalOverflows ||
                      nextOverflows ||
                      costOverflows;

                  final content = _buildContent(
                    theme: theme,
                    title: rule.title,
                    titleStyle: titleStyle,
                    intervalLabel: intervalLabel,
                    intervalStyle: intervalStyle,
                    nextLabel: nextLabel,
                    nextStyle: nextStyle,
                    costLabel: costLabel,
                    costStyle: costStyle,
                    collapsed: canExpand && !expanded,
                  );

                  // Если раздвигать нечего — карточка не интерактивна
                  // для тапа: нет InkWell, нет onTap, нет ripple.
                  if (!canExpand) {
                    return content;
                  }

                  return InkWell(
                    onTap: () => onToggle(true),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedSize(
                      duration: _animDuration,
                      curve: _animCurve,
                      alignment: Alignment.topLeft,
                      clipBehavior: Clip.hardEdge,
                      child: content,
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: theme.colorScheme.primary,
              onPressed: onEdit,
              tooltip: l10n.actionEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: theme.colorScheme.error,
              onPressed: onDelete,
              tooltip: l10n.actionDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required ThemeData theme,
    required String title,
    required TextStyle? titleStyle,
    required String intervalLabel,
    required TextStyle? intervalStyle,
    required String nextLabel,
    required TextStyle? nextStyle,
    required String? costLabel,
    required TextStyle? costStyle,
    required bool collapsed,
  }) {
    final maxLines = collapsed ? _collapsedMaxLines : null;
    final overflow = collapsed ? TextOverflow.ellipsis : TextOverflow.visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: titleStyle,
          maxLines: maxLines,
          overflow: overflow,
        ),
        const SizedBox(height: 6),
        Text(
          intervalLabel,
          style: intervalStyle,
          maxLines: maxLines,
          overflow: overflow,
        ),
        const SizedBox(height: 2),
        Text(
          nextLabel,
          style: nextStyle,
          maxLines: maxLines,
          overflow: overflow,
        ),
        if (costLabel != null) ...[
          const SizedBox(height: 2),
          Text(
            costLabel,
            style: costStyle,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ],
      ],
    );
  }
}
