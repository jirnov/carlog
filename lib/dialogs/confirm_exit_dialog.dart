// lib/dialogs/confirm_exit_dialog.dart

import 'package:flutter/material.dart';

/// Диалог подтверждения выхода без сохранения.
Future<bool> showConfirmExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Выйти без сохранения?'),
      content: const Text('Все изменения будут утеряны'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Выйти'),
        ),
      ],
    ),
  );
  return result ?? false;
}
