// lib/dialogs/confirm_cancel_dialog.dart

import 'package:flutter/material.dart';

/// Диалог подтверждения отмены ТО.
/// Возвращает true, если пользователь подтвердил.
Future<bool> showConfirmCancelDialog(
  BuildContext context, {
  required String ruleTitle,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Отменить ТО?'),
      content: Text(
        'Работа «$ruleTitle» будет помечена как отменённая. '
        'Она попадёт в историю со значком отмены и не будет '
        'считаться выполненной. Следующее ТО сдвинется на '
        'текущий пробег.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Отменить'),
        ),
      ],
    ),
  );
  return result ?? false;
}
