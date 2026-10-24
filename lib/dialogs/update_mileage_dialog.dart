// lib/dialogs/update_mileage_dialog.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/utils/formatting.dart';

/// Порог, при превышении которого пробег считается подозрительным.
/// Если новый пробег больше предыдущего более чем на это значение —
/// показываем предупреждение.
const int _suspiciousJumpKm = 50000;

/// Показать диалог обновления пробега.
/// Возвращает новое значение или null, если пользователь отменил.
Future<int?> showUpdateMileageDialog(
  BuildContext context, {
  required int previousMileage,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) => _UpdateMileageDialog(
      previousMileage: previousMileage,
    ),
  );
}

class _UpdateMileageDialog extends StatefulWidget {
  const _UpdateMileageDialog({required this.previousMileage});

  final int previousMileage;

  @override
  State<_UpdateMileageDialog> createState() => _UpdateMileageDialogState();
}

class _UpdateMileageDialogState extends State<_UpdateMileageDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _errorText;

  static const _maxMileage = 10000000;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int? get _value => parseThousands(_controller.text);

  String? _validate(int? value) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    if (value == null) return l10n.requiredField;
    if (value <= 0) return l10n.mileageErrorPositive;
    if (value < widget.previousMileage) {
      return l10n.mileageErrorMin(
        km: formatThousands(widget.previousMileage, locale),
      );
    }
    if (value > _maxMileage) return l10n.mileageErrorTooLarge;
    return null;
  }

  bool get _canSave => _validate(_value) == null;

  void _onChanged(String _) {
    setState(() {
      _errorText = _controller.text.isEmpty ? null : _validate(_value);
    });
  }

  /// Проверяет, не выглядит ли пробег подозрительно большим.
  /// Если да — показывает диалог подтверждения.
  /// Возвращает true, если пользователь согласен продолжить.
  Future<bool> _confirmLargeJump(int value) async {
    final diff = value - widget.previousMileage;
    if (diff <= _suspiciousJumpKm) return true;

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.mileageJumpTitle),
        content: Text(
          l10n.mileageJumpMessage(
            previous: formatThousands(widget.previousMileage, locale),
            current: formatThousands(value, locale),
            diff: formatThousands(diff, locale),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.mileageJumpEdit),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.mileageJumpConfirm),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _onSave() async {
    final error = _validate(_value);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    final value = _value!;

    // Проверка на подозрительно большой скачок.
    final confirmed = await _confirmLargeJump(value);
    if (!confirmed) return;
    if (!mounted) return;

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    return AlertDialog(
      scrollable: true,
      title: Text(l10n.actionUpdateMileage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              ThousandsSeparatorFormatter(locale: locale),
            ],
            onChanged: _onChanged,
            onSubmitted: (_) {
              if (_canSave) _onSave();
            },
            decoration: InputDecoration(
              labelText: l10n.updateMileageFieldLabel,
              suffixText: l10n.unitKm,
              errorText: _errorText,
            ),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.updateMileagePrevious(
              km: formatThousands(widget.previousMileage, locale),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.updateMileageDateToday,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: _canSave ? _onSave : null,
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
