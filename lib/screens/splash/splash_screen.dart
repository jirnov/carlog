// lib/screens/splash/splash_screen.dart

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/dialogs/confirm_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/screens/app_root.dart';
import 'package:carlog/services/backup_service.dart';
import 'package:carlog/services/notification_service.dart';

/// Минимальное время показа splash, чтобы он не мигал.
const Duration _minSplashDuration = Duration(milliseconds: 1500);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _ready = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = false;
      _ready = false;
    });

    try {
      final backupService = context.read<BackupService>();

      await Future.wait([
        // Минимальное время показа splash.
        Future<void>.delayed(_minSplashDuration),
        // Загрузка данных.
        context.read<SettingsProvider>().load(),
        context.read<MileageProvider>().load(),
        context.read<RulesProvider>().load(),
        context.read<HistoryProvider>().load(),
        context.read<PostponementsProvider>().load(),
      ]);

      // Тихий бэкап после загрузки.
      await backupService.createBackupIfNeeded();

      if (!mounted) return;

      // Свой диалог перед запросом разрешения на уведомления.
      await _maybeAskNotificationsPermission();

      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      debugPrint('Splash load error: $e');
      if (!mounted) return;
      setState(() => _error = true);
    }
  }

  /// Спросить разрешение на уведомления один раз (при первом запуске).
  ///
  /// - Android 13+: свой диалог-прелюдия, затем системный диалог.
  /// - Android < 13: своего системного диалога нет, показываем свой
  ///   и при согласии открываем настройки уведомлений приложения.
  /// - iOS: свой диалог-прелюдия, затем системный диалог.
  Future<void> _maybeAskNotificationsPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    final settings = context.read<SettingsProvider>();

    // Уже спрашивали — не спрашиваем.
    if (settings.notificationsAsked) return;

    final notifications = context.read<NotificationService>();
    final l10n = context.l10n;

    // Если разрешение уже выдано — просто помечаем, что спросили.
    if (await notifications.hasPermission()) {
      await settings.setNotificationsAsked(true);
      return;
    }

    if (!mounted) return;

    final canShowSystemDialog =
        await notifications.canRequestSystemPermission();

    if (!mounted) return;

    final agreed = await showConfirmDialog(
      context,
      title: l10n.notificationsPermissionTitle,
      message: canShowSystemDialog
          ? l10n.notificationsPermissionMessageSystem
          : l10n.notificationsPermissionMessageSettings,
      confirmText: l10n.actionYes,
      cancelText: l10n.actionNo,
      isDestructive: false,
    );

    if (!mounted) return;

    if (agreed) {
      if (canShowSystemDialog) {
        // Android 13+ / iOS — покажет системный диалог.
        await notifications.requestPermissions();
      } else {
        // Android < 13 — системного диалога нет, ведём в настройки.
        await notifications.openAppNotificationSettings();
      }
    }

    // Помечаем, что спросили — больше не будем.
    await settings.setNotificationsAsked(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return const AppRoot();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _error ? _buildError() : _buildLoading(),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/app_icon.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 32),
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(Color(0xFF1565C0)),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/app_icon.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.splashLoadError,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _load,
          child: Text(l10n.splashRetry),
        ),
      ],
    );
  }
}
