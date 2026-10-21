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

/// Ссылки приложения. Вынести сюда, чтобы менять в одном месте.
const String kAppName = 'Журнал ТО';
const String kPlayStoreUrl = String.fromEnvironment(
  'STORE_URL',
  defaultValue:
      'https://play.google.com/store/apps/details?id=ru.blog2k.carlog',
);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: const [
          _SectionHeader('Автомобиль'),
          _CarNameTile(),
          _SectionHeader('Напоминания о пробеге'),
          _RemindEnabledTile(),
          _RemindDaysTile(),
          _SectionHeader('Пороги предупреждения'),
          _YellowKmTile(),
          _YellowMonthsTile(),
          _SectionHeader('Внешний вид'),
          _ThemeModeTile(),
          _SectionHeader('Данные'),
          _ExportTile(),
          _ImportTile(),
          _RestoreBackupTile(),
          _SectionHeader('Помощь и поддержка'),
          _HelpTile(),
          _ShareTile(),
          _CoffeeTile(),
          _SectionHeader('О приложении'),
          _VersionTile(),
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
    final provider = context.read<SettingsProvider>();
    final controller = TextEditingController(text: provider.carName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Название машины'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Например, Моя ласточка',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Сохранить'),
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
    final carName = context.select<SettingsProvider, String>(
      (p) => p.carName,
    );

    return ListTile(
      title: const Text('Название'),
      subtitle: Text(carName.isEmpty ? 'Не задано' : carName),
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
    final enabled = context.select<SettingsProvider, bool>(
      (p) => p.remindEnabled,
    );

    return SwitchListTile(
      title: const Text('Напоминать об обновлении пробега'),
      value: enabled,
      onChanged: (value) =>
          context.read<SettingsProvider>().setRemindEnabled(value),
    );
  }
}

class _RemindDaysTile extends StatelessWidget {
  const _RemindDaysTile();

  Future<void> _edit(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    if (!provider.remindEnabled) return;

    final controller = TextEditingController(
      text: provider.remindDays.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Напоминать каждые'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(suffixText: 'дней'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              Navigator.of(context).pop(value);
            },
            child: const Text('Сохранить'),
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
    final enabled = context.select<SettingsProvider, bool>(
      (p) => p.remindEnabled,
    );
    final days = context.select<SettingsProvider, int>(
      (p) => p.remindDays,
    );

    return ListTile(
      enabled: enabled,
      title: const Text('Как часто'),
      subtitle: Text('$days ${pluralWorks(days)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}

// --- Пороги ---

class _YellowKmTile extends StatelessWidget {
  const _YellowKmTile();

  Future<void> _edit(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final controller = TextEditingController(
      text: formatThousands(provider.yellowKm),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Порог предупреждения по км'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: const [ThousandsSeparatorFormatter()],
          decoration: const InputDecoration(suffixText: 'км'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(parseThousands(controller.text)),
            child: const Text('Сохранить'),
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
    final km = context.select<SettingsProvider, int>((p) => p.yellowKm);
    return ListTile(
      title: const Text('За сколько км'),
      subtitle: Text('${formatThousands(km)} км'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}

class _YellowMonthsTile extends StatelessWidget {
  const _YellowMonthsTile();

  Future<void> _edit(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final controller = TextEditingController(
      text: provider.yellowMonths.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Порог предупреждения по сроку'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(suffixText: 'мес'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              Navigator.of(context).pop(value);
            },
            child: const Text('Сохранить'),
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
    final months = context.select<SettingsProvider, int>(
      (p) => p.yellowMonths,
    );
    return ListTile(
      title: const Text('За сколько месяцев'),
      subtitle: Text('$months ${pluralWorks(months)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _edit(context),
    );
  }
}

// --- Внешний вид ---

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  String _label(ThemeModePreference pref) {
    switch (pref) {
      case ThemeModePreference.system:
        return 'Как в системе';
      case ThemeModePreference.light:
        return 'Светлая';
      case ThemeModePreference.dark:
        return 'Тёмная';
    }
  }

  Future<void> _pick(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final current = provider.themeModePreference;

    final result = await showDialog<ThemeModePreference>(
      context: context,
      builder: (dialogContext) {
        var selected = current;
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: const Text('Тема оформления'),
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
                        title: Text(_label(pref)),
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
    final pref = context.select<SettingsProvider, ThemeModePreference>(
      (p) => p.themeModePreference,
    );

    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: const Text('Тема'),
      subtitle: Text(_label(pref)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pick(context),
    );
  }
}

// --- Данные ---

class _ExportTile extends StatelessWidget {
  const _ExportTile();

  Future<void> _export(BuildContext context) async {
    final provider = context.read<ExportImportProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final path = await provider.export();
    if (path == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Не удалось сохранить файл')),
      );
      return;
    }

    try {
      final params = ShareParams(
        files: [XFile(path)],
        subject: 'Журнал ТО — резервная копия',
      );
      await SharePlus.instance.share(params);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text('Файл сохранён: $path')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = context.select<ExportImportProvider, bool>(
      (p) => p.isBusy,
    );

    return ListTile(
      enabled: !isBusy,
      leading: const Icon(Icons.file_upload_outlined),
      title: const Text('Экспорт данных'),
      subtitle: const Text('Сохранить всё в JSON-файл'),
      onTap: () => _export(context),
    );
  }
}

class _ImportTile extends StatelessWidget {
  const _ImportTile();

  Future<void> _import(BuildContext context) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Импортировать данные?',
      message: 'Все текущие данные будут заменены содержимым файла.',
      confirmText: 'Импортировать',
      cancelText: 'Отмена',
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
        const SnackBar(
          content: Text('Выберите файл с расширением .json'),
        ),
      );
      return;
    }

    final provider = context.read<ExportImportProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final success = await provider.import(path);
    if (!success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Не удалось импортировать файл')),
      );
      return;
    }

    if (!context.mounted) return;
    await _reloadAllProviders(context);

    if (!context.mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Данные импортированы')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = context.select<ExportImportProvider, bool>(
      (p) => p.isBusy,
    );

    return ListTile(
      enabled: !isBusy,
      leading: const Icon(Icons.file_download_outlined),
      title: const Text('Импорт данных'),
      subtitle: const Text('Загрузить из JSON-файла'),
      onTap: () => _import(context),
    );
  }
}

/// Пункт «Восстановить из архива» — выбор из автоматических бэкапов.
class _RestoreBackupTile extends StatelessWidget {
  const _RestoreBackupTile();

  Future<void> _open(BuildContext context) async {
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
      title: 'Восстановить из архива?',
      message: 'Все текущие данные будут заменены содержимым архива.',
      confirmText: 'Восстановить',
      cancelText: 'Отмена',
    );
    if (!confirmed) return;
    if (!context.mounted) return;

    final success = await provider.import(path);
    if (!success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Не удалось восстановить архив')),
      );
      return;
    }

    if (!context.mounted) return;
    await _reloadAllProviders(context);

    if (!context.mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Данные восстановлены из архива')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = context.select<ExportImportProvider, bool>(
      (p) => p.isBusy,
    );

    return ListTile(
      enabled: !isBusy,
      leading: const Icon(Icons.restore_outlined),
      title: const Text('Восстановить из архива'),
      subtitle: const Text('Автоматические резервные копии'),
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
    return AlertDialog(
      title: const Text('Восстановить из архива'),
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
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Архивных копий пока нет'),
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
                    ? '$size Б'
                    : '${(size / 1024).toStringAsFixed(1)} КБ';

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
          child: const Text('Отмена'),
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
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text('Помощь'),
      subtitle: const Text('Как пользоваться приложением'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const HelpScreen(),
          ),
        );
      },
    );
  }
}

class _ShareTile extends StatelessWidget {
  const _ShareTile();

  Future<void> _share() async {
    final params = ShareParams(
      text: 'Попробуй приложение «$kAppName» — дневник обслуживания '
          'автомобиля.\n\n'
          '$kPlayStoreUrl',
      subject: kAppName,
    );
    await SharePlus.instance.share(params);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.share_outlined),
      title: const Text('Поделиться приложением'),
      subtitle: const Text('Отправить ссылку на магазин'),
      onTap: _share,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final beerColor = isDark ? Colors.amber.shade400 : Colors.brown.shade600;

    return ListTile(
      leading: Transform.flip(
        flipX: true,
        child: Icon(
          Icons.sports_bar,
          color: beerColor,
        ),
      ),
      title: const Text('Угостить автора бокалом кофе'),
      subtitle: const Text('Поддержать разработку'),
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
      _version = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('Версия'),
      subtitle: Text(_version ?? '…'),
    );
  }
}
