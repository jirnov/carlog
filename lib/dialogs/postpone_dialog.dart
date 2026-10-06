// lib/dialogs/postpone_dialog.dart

import 'package:flutter/material.dart';

import 'package:carlog/utils/formatting.dart';

/// Показать диалог отложки ТО.
/// Возвращает дату, до которой отложить, или null.
Future<DateTime?> showPostponeDialog(
  BuildContext context, {
  required String ruleTitle,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _PostponeDialog(ruleTitle: ruleTitle),
  );
}

enum _PostponeOption { threeDays, oneWeek, oneMonth, custom }

class _PostponeDialog extends StatefulWidget {
  const _PostponeDialog({required this.ruleTitle});

  final String ruleTitle;

  @override
  State<_PostponeDialog> createState() => _PostponeDialogState();
}

class _PostponeDialogState extends State<_PostponeDialog> {
  _PostponeOption _option = _PostponeOption.oneWeek;
  DateTime? _customDate;

  DateTime get _resultDate {
    final today = dateOnly(DateTime.now());
    switch (_option) {
      case _PostponeOption.threeDays:
        return today.add(const Duration(days: 3));
      case _PostponeOption.oneWeek:
        return today.add(const Duration(days: 7));
      case _PostponeOption.oneMonth:
        return DateTime(today.year, today.month + 1, today.day);
      case _PostponeOption.custom:
        return _customDate ?? today;
    }
  }

  bool get _canSubmit {
    if (_option != _PostponeOption.custom) return true;
    return _customDate != null;
  }

  Future<void> _pickCustomDate() async {
    final today = dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _customDate ?? today.add(const Duration(days: 7)),
      firstDate: today.add(const Duration(days: 1)),
      lastDate: today.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _customDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Отложить ТО'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.ruleTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text('На какой срок?', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),

            // RadioGroup управляет значением группы; каждый RadioListTile
            // передаёт только свой value.
            RadioGroup<_PostponeOption>(
              groupValue: _option,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _option = value);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<_PostponeOption>(
                    value: _PostponeOption.threeDays,
                    title: const Text('На 3 дня'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  RadioListTile<_PostponeOption>(
                    value: _PostponeOption.oneWeek,
                    title: const Text('На неделю'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  RadioListTile<_PostponeOption>(
                    value: _PostponeOption.oneMonth,
                    title: const Text('На месяц'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  RadioListTile<_PostponeOption>(
                    value: _PostponeOption.custom,
                    title: const Text('Свой срок'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ],
              ),
            ),

            if (_option == _PostponeOption.custom) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickCustomDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Дата',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _customDate != null
                        ? _formatDate(_customDate!)
                        : 'Выберите дату',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed:
              _canSubmit ? () => Navigator.of(context).pop(_resultDate) : null,
          child: const Text('Отложить'),
        ),
      ],
    );
  }
}
