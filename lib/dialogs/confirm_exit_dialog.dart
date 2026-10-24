// lib/dialogs/confirm_exit_dialog.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/context_l10n.dart';

/// Диалог подтверждения выхода без сохранения.
Future<bool> showConfirmExitDialog(BuildContext context) async {
  final l10n = context.l10n;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.confirmExitTitle),
      content: Text(l10n.confirmExitMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(l10n.actionExit),
        ),
      ],
    ),
  );
  return result ?? false;
}
