// lib/dialogs/update_mileage_dialog.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:carlog/dialogs/confirm_dialog.dart';
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

    final confirmed = await showConfirmDialog(
      context,
      title: l10n.mileageJumpTitle,
      message: l10n.mileageJumpMessage(
        previous: formatThousands(widget.previousMileage, locale),
        current: formatThousands(value, locale),
        diff: formatThousands(diff, locale),
      ),
      confirmText: l10n.mileageJumpConfirm,
      cancelText: l10n.mileageJumpEdit,
      isDestructive: false,
    );
    return confirmed;
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

    final dialogWidth = math.min(
      MediaQuery.sizeOf(context).width * 0.8,
      400.0,
    );

    // ВАЖНО: Dialog вместо AlertDialog — иначе FilledButton в actions
    // падает с "BoxConstraints forces an infinite width".
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.actionUpdateMileage,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.actionCancel),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FilledButton(
                      onPressed: _canSave ? _onSave : null,
                      child: Text(l10n.actionSave),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
