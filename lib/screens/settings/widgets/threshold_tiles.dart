// lib/screens/settings/widgets/threshold_tiles.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/utils/formatting.dart';

class YellowKmTile extends StatelessWidget {
  const YellowKmTile({super.key});

  Future<void> _edit(BuildContext context) async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final provider = context.read<SettingsProvider>();
    final controller = TextEditingController(
      text: formatThousands(provider.yellowKm, locale),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsYellowKmDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            ThousandsSeparatorFormatter(locale: locale),
          ],
          decoration: InputDecoration(suffixText: l10n.unitKm),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(parseThousands(controller.text)),
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );

    if (result != null && result > 0 && context.mounted) {
      await provider.setYellowKm(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final km = context.select<SettingsProvider, int>((p) => p.yellowKm);
    return ListTile(
      title: Text(l10n.settingsYellowKmTitle),
      subtitle: Text(
        l10n.kmWithValue(km: formatThousands(km, locale)),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}

class YellowMonthsTile extends StatelessWidget {
  const YellowMonthsTile({super.key});

  Future<void> _edit(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<SettingsProvider>();
    final controller = TextEditingController(
      text: provider.yellowMonths.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsYellowMonthsDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(suffixText: l10n.unitMonths),
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
      await provider.setYellowMonths(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final months = context.select<SettingsProvider, int>((p) => p.yellowMonths);
    return ListTile(
      title: Text(l10n.settingsYellowMonthsTitle),
      subtitle: Text(l10n.monthsWithValue(months: months)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}