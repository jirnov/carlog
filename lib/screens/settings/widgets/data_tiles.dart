// lib/screens/settings/widgets/data_tiles.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:carlog/dialogs/confirm_delete_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/due_list_provider.dart';
import 'package:carlog/providers/export_import_provider.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/services/backup_service.dart';

/// Перезагрузить все провайдеры после импорта.
Future<void> reloadAllProviders(BuildContext context) async {
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

class ExportTile extends StatelessWidget {
  const ExportTile({super.key});

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

class ImportTile extends StatelessWidget {
  const ImportTile({super.key});

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
    await reloadAllProviders(context);

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

class RestoreBackupTile extends StatelessWidget {
  const RestoreBackupTile({super.key});

  Future<void> _open(BuildContext context) async {
    final l10n = context.l10n;
    final backupService = context.read<BackupService>();
    final provider = context.read<ExportImportProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final path = await showDialog<String>(
      context: context,
      builder: (_) => BackupPickerDialog(backupService: backupService),
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
    await reloadAllProviders(context);

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

class BackupPickerDialog extends StatefulWidget {
  const BackupPickerDialog({super.key, required this.backupService});

  final BackupService backupService;

  @override
  State<BackupPickerDialog> createState() => _BackupPickerDialogState();
}

class _BackupPickerDialogState extends State<BackupPickerDialog> {
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