// lib/screens/history/widgets/history_card.dart

import 'package:flutter/material.dart';

import 'package:carlog/data/models/history_record.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/utils/formatting.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.record,
    required this.expanded,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final HistoryRecord record;
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
    final locale = Localizations.localeOf(context).languageCode;
    final subtleColor = theme.colorScheme.onSurfaceVariant;

    final titleStyle = theme.textTheme.titleMedium;
    final noteStyle = theme.textTheme.bodySmall?.copyWith(color: subtleColor);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;

                  final titleOverflows =
                      _willOverflow(context, record.title, titleStyle, maxW);
                  final noteOverflows = record.note.isNotEmpty &&
                      _willOverflow(context, record.note, noteStyle, maxW);
                  final canExpand = titleOverflows || noteOverflows;

                  final content = _buildContent(
                    theme: theme,
                    l10n: l10n,
                    locale: locale,
                    subtleColor: subtleColor,
                    titleStyle: titleStyle,
                    noteStyle: noteStyle,
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
    required dynamic l10n,
    required String locale,
    required Color subtleColor,
    required TextStyle? titleStyle,
    required TextStyle? noteStyle,
    required bool collapsed,
  }) {
    final maxLines = collapsed ? _collapsedMaxLines : null;
    final overflow = collapsed ? TextOverflow.ellipsis : TextOverflow.visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          record.title,
          style: titleStyle,
          maxLines: maxLines,
          overflow: overflow,
        ),
        if (record.note.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            record.note,
            style: noteStyle,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ],
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              l10n.kmWithValue(
                km: formatThousands(record.mileage, locale),
              ),
              style: theme.textTheme.bodyMedium,
              maxLines: maxLines,
              overflow: overflow,
            ),
            Text(
              ' · ${formatMonthYear(record.performedAt, locale)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: subtleColor,
              ),
              maxLines: maxLines,
              overflow: overflow,
            ),
          ],
        ),
        if (record.hasCost) ...[
          const SizedBox(height: 2),
          Text(
            l10n.historyCardCost(
              amount: formatThousands(record.cost!.round(), locale),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
            maxLines: maxLines,
            overflow: overflow,
          ),
        ],
      ],
    );
  }
}
