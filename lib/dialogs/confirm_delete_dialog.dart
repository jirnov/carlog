// lib/dialogs/confirm_delete_dialog.dart

import 'package:carlog/l10n/context_l10n.dart';
import 'package:flutter/material.dart';

/// Универсальный диалог подтверждения удаления.
/// Возвращает true, если пользователь подтвердил.
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(confirmText ?? l10n.actionDelete),
        ),
      ],
    ),
  );
  return result ?? false;
}
