// lib/screens/settings/widgets/reminders_tiles.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/services/notification_service.dart';

class RemindEnabledTile extends StatefulWidget {
  const RemindEnabledTile({super.key});

  @override
  State<RemindEnabledTile> createState() => _RemindEnabledTileState();
}

class _RemindEnabledTileState extends State<RemindEnabledTile> {
  bool? _hasPermission;

  @override
  void initState() {
    super.initState();
    _loadPermission();
  }

  Future<void> _loadPermission() async {
    final notifications = context.read<NotificationService>();
    final granted = await notifications.hasPermission();
    if (!mounted) return;
    setState(() => _hasPermission = granted);
  }

  Future<void> _onToggle(bool value) async {
    final provider = context.read<SettingsProvider>();
    final notifications = context.read<NotificationService>();
    final l10n = context.l10n;

    if (!value) {
      // Выключение — просто выключаем.
      await provider.setRemindEnabled(false);
      return;
    }

    // Включение — проверяем разрешение.
    final granted = await notifications.hasPermission();
    if (!mounted) return;

    if (granted) {
      await provider.setRemindEnabled(true);
      return;
    }

    // Нет разрешения — свой диалог → системный.
    final shouldAsk = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.notificationsPermissionTitle),
        content: Text(l10n.notificationsPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.actionYes),
          ),
        ],
      ),
    );

    if (shouldAsk != true) return;
    if (!mounted) return;

    final grantedBySystem = await notifications.requestPermissions();
    if (!mounted) return;

    if (grantedBySystem) {
      await provider.setRemindEnabled(true);
    }

    setState(() => _hasPermission = grantedBySystem);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final enabled = context.select<SettingsProvider, bool>(
      (p) => p.remindEnabled,
    );
    final hasPermission = _hasPermission ?? true;

    // Если разрешение не выдано — показываем «отключено» независимо от настройки.
    final effectiveValue = enabled && hasPermission;

    return SwitchListTile(
      title: Text(l10n.settingsRemindEnabled),
      subtitle: hasPermission ? null : Text(l10n.settingsNotificationsDisabled),
      value: effectiveValue,
      onChanged: _onToggle,
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
