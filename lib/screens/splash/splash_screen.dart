// lib/screens/splash/splash_screen.dart

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

      // Свой диалог перед системным запросом разрешения (только если
      // разрешение ещё не выдано).
      await _maybeAskNotificationsPermission();

      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      debugPrint('Splash load error: $e');
      if (!mounted) return;
      setState(() => _error = true);
    }
  }

  /// Показать свой диалог и, если пользователь согласился,
  /// вызвать системный запрос разрешения на уведомления.
  ///
  /// Если разрешение уже выдано — ничего не показывает.
  Future<void> _maybeAskNotificationsPermission() async {
    // На не-Android системный диалог не нужен.
    if (!Platform.isAndroid) return;

    final notifications = context.read<NotificationService>();
    final l10n = context.l10n;

    // Уже выдано — не спрашиваем.
    if (await notifications.hasPermission()) return;
    if (!mounted) return;

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

    if (shouldAsk == true) {
      await notifications.requestPermissions();
    }
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
