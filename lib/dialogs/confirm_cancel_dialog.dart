// lib/dialogs/confirm_cancel_dialog.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/context_l10n.dart';

/// Диалог подтверждения отмены ТО.
/// Возвращает true, если пользователь подтвердил.
Future<bool> showConfirmCancelDialog(
  BuildContext context, {
  required String ruleTitle,
}) async {
  final l10n = context.l10n;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.confirmCancelTitle),
      content: Text(l10n.confirmCancelMessage(ruleTitle: ruleTitle)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.actionConfirmCancel),
        ),
      ],
    ),
  );
  return result ?? false;
}
