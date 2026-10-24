// lib/screens/settings/widgets/car_name_tile.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/settings_provider.dart';

class CarNameTile extends StatelessWidget {
  const CarNameTile({super.key});

  Future<void> _edit(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<SettingsProvider>();
    final controller = TextEditingController(text: provider.carName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsCarNameDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.settingsCarNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      await provider.setCarName(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final carName = context.select<SettingsProvider, String>((p) => p.carName);

    return ListTile(
      title: Text(l10n.settingsCarNameTitle),
      subtitle: Text(
        carName.isEmpty ? l10n.settingsCarNameNotSet : carName,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}