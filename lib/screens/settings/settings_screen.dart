// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'app_store.dart';
import 'widgets/appearance_tiles.dart';
import 'widgets/car_name_tile.dart';
import 'widgets/data_tiles.dart';
import 'widgets/reminders_tiles.dart';
import 'widgets/support_tiles.dart';
import 'widgets/threshold_tiles.dart';
import 'widgets/version_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _SectionHeader(l10n.settingsSectionCar),
          const CarNameTile(),
          _SectionHeader(l10n.settingsSectionReminders),
          const RemindEnabledTile(),
          const RemindDaysTile(),
          _SectionHeader(l10n.settingsSectionThresholds),
          const YellowKmTile(),
          const YellowMonthsTile(),
          _SectionHeader(l10n.settingsSectionAppearance),
          const ThemeModeTile(),
          const LocaleTile(),
          _SectionHeader(l10n.settingsSectionData),
          const ExportTile(),
          const ImportTile(),
          const RestoreBackupTile(),
          _SectionHeader(l10n.settingsSectionSupport),
          const HelpTile(),
          if (kStoreUrl != null) ShareTile(storeUrl: kStoreUrl!),
          const CoffeeTile(),
          _SectionHeader(l10n.settingsSectionAbout),
          const VersionTile(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}