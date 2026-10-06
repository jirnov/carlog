// lib/dialogs/confirm_delete_dialog.dart

import 'package:flutter/material.dart';

/// Универсальный диалог подтверждения удаления.
/// Возвращает true, если пользователь подтвердил.
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Удалить',
  String cancelText = 'Отмена',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}
