// lib/screens/settings/settings_screen.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:carlog/data/models/theme_mode_preference.dart';
import 'package:carlog/dialogs/confirm_delete_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/due_list_provider.dart';
import 'package:carlog/providers/export_import_provider.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/screens/help/help_screen.dart';
import 'package:carlog/services/backup_service.dart';
import 'package:carlog/utils/formatting.dart';

enum AppStore {
  none,
  googlePlay,
  rustore;

  /// Разбирает имя flavor (`googleplay`, `rustore`, ...).
  /// В непрофильных сборках `appFlavor` пустой — вернётся [AppStore.none].
  static AppStore fromName(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'googleplay':
        return AppStore.googlePlay;
      case 'rustore':
        return AppStore.rustore;
      default:
        return AppStore.none;
    }
  }

  String? get url {
    switch (this) {
      case AppStore.googlePlay:
        return 'https://play.google.com/store/apps/details?id=ru.blog2k.carlog';
      case AppStore.rustore:
        return 'https://www.rustore.ru/catalog/app/ru.blog2k.carlog';
      case AppStore.none:
        return null;
    }
  }
}

/// Текущий магазин определяется flavor-сборкой (`--flavor googleplay` / `--flavor rustore`).
/// Значение `appFlavor` задаётся Flutter на этапе компиляции.
final String _kFlavor = appFlavor ?? '';
final AppStore kCurrentStore = AppStore.fromName(_kFlavor);
final String? kStoreUrl = kCurrentStore.url;

const String kCoffeeUrl = 'https://pay.cloudtips.ru/p/31704978';

/// Перезагрузить все провайдеры после импорта.
/// Используется и в «Импорт», и в «Восстановить из архива».
Future<void> _reloadAllProviders(BuildContext context) async {
  await context.read<SettingsProvider>().reload();
  if (!context.mounted) return;
  await context.read<MileageProvider>().reload();
  if (!context.mounted) return;
  await context.read<RulesProvider>().reload();
  if (!context.mounted) return;
  await context.read<HistoryProvider>().reload();
  if (!context.mounted) return;
  await context.read<PostponementsProvider>().reload();
  if (!context.mounted) return;
  await context.read<DueListProvider>().reload();
}

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
          const _CarNameTile(),
          _SectionHeader(l10n.settingsSectionReminders),
          const _RemindEnabledTile(),
          const _RemindDaysTile(),
          _SectionHeader(l10n.settingsSectionThresholds),
          const _YellowKmTile(),
          const _YellowMonthsTile(),
          _SectionHeader(l10n.settingsSectionAppearance),
          const _ThemeModeTile(),
          _SectionHeader(l10n.settingsSectionData),
          const _ExportTile(),
          const _ImportTile(),
          const _RestoreBackupTile(),
          _SectionHeader(l10n.settingsSectionSupport),
          const _HelpTile(),
          if (kStoreUrl != null) _ShareTile(storeUrl: kStoreUrl!),
          const _CoffeeTile(),
          _SectionHeader(l10n.settingsSectionAbout),
          const _VersionTile(),
        ],
      ),
    );
  }
}

// --- Секции ---

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

// --- Название машины ---

class _CarNameTile extends StatelessWidget {
  const _CarNameTile();

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

// --- Напоминания ---

class _RemindEnabledTile extends StatelessWidget {
  const _RemindEnabledTile();

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

class _RemindDaysTile extends StatelessWidget {
  const _RemindDaysTile();

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

// --- Пороги ---

class _YellowKmTile extends StatelessWidget {
  const _YellowKmTile();

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

class _YellowMonthsTile extends StatelessWidget {
  const _YellowMonthsTile();

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
          decoration: InputDecoration(
            suffixText: l10n.unitMonths,
          ),
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
      subtitle: Text(
        l10n.monthsWithValue(months: months),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}

// --- Внешний вид ---

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  String _label(BuildContext context, ThemeModePreference pref) {
    final l10n = context.l10n;
    switch (pref) {
      case ThemeModePreference.system:
        return l10n.themeSystem;
      case ThemeModePreference.light:
        return l10n.themeLight;
      case ThemeModePreference.dark:
        return l10n.themeDark;
    }
  }

  Future<void> _pick(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<SettingsProvider>();
    final current = provider.themeModePreference;

    final result = await showDialog<ThemeModePreference>(
      context: context,
      builder: (dialogContext) {
        var selected = current;
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: Text(l10n.themeDialogTitle),
            children: [
              RadioGroup<ThemeModePreference>(
                groupValue: selected,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selected = value);
                  Navigator.of(dialogContext).pop(value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final pref in ThemeModePreference.values)
                      RadioListTile<ThemeModePreference>(
                        value: pref,
                        title: Text(_label(context, pref)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      await provider.setThemeMode(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pref = context.select<SettingsProvider, ThemeModePreference>(
      (p) => p.themeModePreference,
    );

    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text(l10n.settingsThemeTitle),
      subtitle: Text(_label(context, pref)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pick(context),
    );
  }
}

// --- Данные ---

class _ExportTile extends StatelessWidget {
  const _ExportTile();

  Future<void> _export(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<ExportImportProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final path = await provider.export();
    if (path == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsExportFailed)),
      );
      return;
    }

    try {
      final params = ShareParams(
        files: [XFile(path)],
        subject: l10n.settingsExportSubject,
      );
      await SharePlus.instance.share(params);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsExportSaved(path: path))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBusy = context.select<ExportImportProvider, bool>((p) => p.isBusy);

    return ListTile(
      enabled: !isBusy,
      leading: const Icon(Icons.file_upload_outlined),
      title: Text(l10n.settingsExportTitle),
      subtitle: Text(l10n.settingsExportSubtitle),
      onTap: () => _export(context),
    );
  }
}

class _ImportTile extends StatelessWidget {
  const _ImportTile();

  Future<void> _import(BuildContext context) async {
    final l10n = context.l10n;

    final confirmed = await showConfirmDeleteDialog(
      context,
      title: l10n.settingsImportConfirmTitle,
      message: l10n.settingsImportConfirmMessage,
      confirmText: l10n.settingsImportConfirmAction,
      cancelText: l10n.actionCancel,
    );
    if (!confirmed) return;
    if (!context.mounted) return;

    final FilePickerResult? picked = await FilePicker.pickFiles(
      type: FileType.any,
    );
    if (picked == null || picked.files.isEmpty) return;

    final file = picked.files.single;
    final path = file.path;
    if (path == null) return;
    if (!context.mounted) return;

    if (!path.toLowerCase().endsWith('.json')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsImportWrongExtension)),
      );
      return;
    }

    final provider = context.read<ExportImportProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final success = await provider.import(path);
    if (!success) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsImportFailed)),
      );
      return;
    }

    if (!context.mounted) return;
    await _reloadAllProviders(context);

    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsImportSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBusy = context.select<ExportImportProvider, bool>((p) => p.isBusy);

    return ListTile(
      enabled: !isBusy,
      leading: const Icon(Icons.file_download_outlined),
      title: Text(l10n.settingsImportTitle),
      subtitle: Text(l10n.settingsImportSubtitle),
      onTap: () => _import(context),
    );
  }
}

/// Пункт «Восстановить из архива» — выбор из автоматических бэкапов.
class _RestoreBackupTile extends StatelessWidget {
  const _RestoreBackupTile();

  Future<void> _open(BuildContext context) async {
    final l10n = context.l10n;
    final backupService = context.read<BackupService>();
    final provider = context.read<ExportImportProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final path = await showDialog<String>(
      context: context,
      builder: (_) => _BackupPickerDialog(backupService: backupService),
    );
    if (path == null) return;
    if (!context.mounted) return;

    final confirmed = await showConfirmDeleteDialog(
      context,
      title: l10n.settingsRestoreConfirmTitle,
      message: l10n.settingsRestoreConfirmMessage,
      confirmText: l10n.settingsRestoreConfirmAction,
      cancelText: l10n.actionCancel,
    );
    if (!confirmed) return;
    if (!context.mounted) return;

    final success = await provider.import(path);
    if (!success) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsRestoreFailed)),
      );
      return;
    }

    if (!context.mounted) return;
    await _reloadAllProviders(context);

    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsRestoreSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBusy = context.select<ExportImportProvider, bool>((p) => p.isBusy);

    return ListTile(
      enabled: !isBusy,
      leading: const Icon(Icons.restore_outlined),
      title: Text(l10n.settingsRestoreTitle),
      subtitle: Text(l10n.settingsRestoreSubtitle),
      onTap: () => _open(context),
    );
  }
}

/// Диалог выбора файла бэкапа. Возвращает путь к выбранному файлу.
class _BackupPickerDialog extends StatefulWidget {
  const _BackupPickerDialog({required this.backupService});

  final BackupService backupService;

  @override
  State<_BackupPickerDialog> createState() => _BackupPickerDialogState();
}

class _BackupPickerDialogState extends State<_BackupPickerDialog> {
  late final Future<List<File>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.backupService.listBackups();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.settingsRestoreTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<List<File>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final files = snapshot.data ?? const <File>[];
            if (files.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.settingsRestoreEmpty),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: files.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final file = files[index];
                final name = file.uri.pathSegments.last;
                final size = file.lengthSync();
                final sizeText = size < 1024
                    ? l10n.settingsBackupSizeBytes(size: size)
                    : l10n.settingsBackupSizeKb(
                        size: (size / 1024).toStringAsFixed(1),
                      );

                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.description_outlined),
                  title: Text(name),
                  subtitle: Text(sizeText),
                  onTap: () => Navigator.of(context).pop(file.path),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
      ],
    );
  }
}

// --- Помощь и поддержка ---

class _HelpTile extends StatelessWidget {
  const _HelpTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: Text(l10n.helpTitle),
      subtitle: Text(l10n.settingsHelpSubtitle),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
      },
    );
  }
}

class _ShareTile extends StatelessWidget {
  const _ShareTile({required this.storeUrl});
  final String storeUrl;

  Future<void> _share(BuildContext context) async {
    final l10n = context.l10n;
    final params = ShareParams(
      text: l10n.settingsShareText(
        appTitle: l10n.appTitle,
        url: storeUrl,
      ),
      subject: l10n.appTitle,
    );
    await SharePlus.instance.share(params);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.share_outlined),
      title: Text(l10n.settingsShareTitle),
      subtitle: Text(l10n.settingsShareSubtitle),
      onTap: () => _share(context),
    );
  }
}

class _CoffeeTile extends StatelessWidget {
  const _CoffeeTile();

  Future<void> _openCoffee() async {
    final uri = Uri.parse(kCoffeeUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Не удалось открыть — ничего страшного.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final beerColor = isDark ? Colors.amber.shade400 : Colors.brown.shade600;

    return ListTile(
      leading: Transform.flip(
        flipX: true,
        child: Icon(Icons.sports_bar, color: beerColor),
      ),
      title: Text(l10n.settingsCoffeeTitle),
      subtitle: Text(l10n.settingsCoffeeSubtitle),
      onTap: _openCoffee,
    );
  }
}

// --- О приложении ---

class _VersionTile extends StatefulWidget {
  const _VersionTile();

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(l10n.settingsVersionTitle),
      subtitle: Text(_version ?? '…'),
    );
  }
}
