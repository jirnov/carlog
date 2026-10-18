// lib/services/notification_service.dart

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const int _mileageReminderId = 1001;

const String _channelId = 'mileage_reminder';
const String _channelName = 'Напоминание о пробеге';
const String _channelDescription = 'Приложение просит обновить пробег машины';

const String _actionUpdate = 'update';
const String _actionClose = 'close';

const String _payloadMileageReminder = 'mileage_reminder';

/// Имя drawable-ресурса для маленькой иконки уведомления.
/// Файл должен лежать в android/app/src/main/res/drawable/.
const String _notificationIcon = '@drawable/ic_notification';

enum NotificationAction {
  openMileage,
  openApp,
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  factory NotificationService() => instance;

  final _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Запрос на открытие диалога обновления пробега.
  /// Инкрементится, когда пользователь нажал «Обновить» в уведомлении.
  /// HomeScreen слушает это значение и при изменении открывает диалог.
  final ValueNotifier<int> openMileageRequests = ValueNotifier<int>(0);

  /// Флаг «есть непрочитанный запрос обновления пробега».
  /// Нужен для холодного старта: приложение могло быть запущено именно
  /// нажатием на «Обновить», и тогда `_handleAction` срабатывает до того,
  /// как HomeScreen успел подписаться на `openMileageRequests`.
  /// HomeScreen при `initState` проверяет флаг и, если он true,
  /// открывает диалог и сбрасывает флаг.
  bool pendingOpenMileage = false;

  void Function(NotificationAction)? onAction;

  /// Поддерживает ли текущая платформа уведомления.
  static bool get _isSupported => Platform.isAndroid || Platform.isIOS;

  Future<void> init() async {
    if (_initialized) return;
    if (!_isSupported) return;
    _initialized = true;

    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings(_notificationIcon);
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundResponse,
    );

    if (Platform.isAndroid) {
      await _createChannel();
    }

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      final response = launchDetails.notificationResponse;
      if (response != null) {
        _handleAction(response);
      }
    }
  }

  static Future<NotificationService> initForBackground() async {
    final service = NotificationService();
    service._initialized = false;
    await service.init();
    return service;
  }

  Future<bool> requestPermissions() async {
    if (!_isSupported) return true;

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return false;
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios == null) return false;
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<void> showMileageReminder({
    required String carName,
    required int daysSinceUpdate,
    int id = _mileageReminderId,
  }) async {
    if (!_isSupported || !_initialized) return;

    final title = carName.isEmpty
        ? 'Пора обновить пробег'
        : '$carName: пора обновить пробег';
    final body = _bodyText(daysSinceUpdate);

    await _plugin.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: _payloadMileageReminder,
    );
  }

  Future<void> scheduleMileageReminder({
    required DateTime when,
    required String carName,
    required int daysSinceUpdate,
    int id = _mileageReminderId,
  }) async {
    if (!_isSupported || !_initialized) return;
    if (when.isBefore(DateTime.now())) return;

    final title = carName.isEmpty
        ? 'Пора обновить пробег'
        : '$carName: пора обновить пробег';
    final body = _bodyText(daysSinceUpdate);

    final scheduled = tz.TZDateTime.from(when, tz.local);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _notificationDetails(),
      payload: _payloadMileageReminder,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelMileageReminder() async {
    if (!_isSupported || !_initialized) return;
    await _plugin.cancel(_mileageReminderId);
  }

  Future<void> cancelAll() async {
    if (!_isSupported || !_initialized) return;
    await _plugin.cancelAll();
  }

  Future<void> dismissMileageReminder() async {
    if (!_isSupported || !_initialized) return;
    await _plugin.cancel(_mileageReminderId);
  }

  String _bodyText(int days) {
    if (days <= 0) return 'Данные о пробеге устарели';
    if (days == 1) return 'Данные устарели 1 день назад';
    return 'Данные устарели $days дней назад';
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        icon: _notificationIcon,
        actions: [
          AndroidNotificationAction(
            _actionUpdate,
            'Обновить',
            showsUserInterface: true,
          ),
          AndroidNotificationAction(
            _actionClose,
            'Закрыть',
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> _createChannel() async {
    if (!_isSupported) return;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
  }

  void _onNotificationResponse(NotificationResponse response) {
    _handleAction(response);
  }

  void _handleAction(NotificationResponse response) {
    final actionId = response.actionId;
    final payload = response.payload;

    if (payload != _payloadMileageReminder) return;

    if (actionId == _actionUpdate) {
      // Сигнал для UI — открыть диалог обновления пробега.
      // Если приложение было запущено именно этим нажатием (холодный старт),
      // HomeScreen ещё не подписан на notifier — тогда выставим флаг.
      pendingOpenMileage = true;
      openMileageRequests.value++;
      onAction?.call(NotificationAction.openMileage);
      return;
    }

    // Нажатие на само уведомление (не на кнопку) — открыть приложение.
    onAction?.call(NotificationAction.openApp);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundResponse(NotificationResponse response) {
    debugPrint('Background notification action: ${response.actionId}');
  }
}
