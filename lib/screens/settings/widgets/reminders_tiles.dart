// lib/screens/settings/widgets/reminders_tiles.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/settings_provider.dart';

class RemindEnabledTile extends StatelessWidget {
  const RemindEnabledTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final enabled = context.select<SettingsProvider, bool>(
      (p) => p.remindEnabled,
    );

    return SwitchListTile(
      title: Text(l10n.settingsRemindEnabled),
      value: enabled,
      onChanged: (value) =>
          context.read<SettingsProvider>().setRemindEnabled(value),
    );
  }
}

class RemindDaysTile extends StatelessWidget {
  const RemindDaysTile({super.key});

  Future<void> _edit(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<SettingsProvider>();
    if (!provider.remindEnabled) return;

    final controller = TextEditingController(
      text: provider.remindDays.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsRemindDaysDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(suffixText: l10n.settingsRemindDaysUnit),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              Navigator.of(context).pop(value);
            },
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );

    if (result != null && result > 0 && context.mounted) {
      await provider.setRemindDays(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final enabled = context.select<SettingsProvider, bool>(
      (p) => p.remindEnabled,
    );
    final days = context.select<SettingsProvider, int>((p) => p.remindDays);

    return ListTile(
      enabled: enabled,
      title: Text(l10n.settingsRemindDaysTitle),
      subtitle: Text(l10n.settingsRemindDaysValue(days: days)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}