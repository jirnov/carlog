// lib/services/notification_service.dart

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:carlog/services/notification_texts.dart';

const int _mileageReminderId = 1001;

const String _channelId = 'mileage_reminder';

const String _actionUpdate = 'update';
const String _actionLater = 'later';

const String _payloadMileageReminder = 'mileage_reminder';

/// Имя drawable-ресурса для маленькой иконки уведомления.
const String _notificationIcon = '@drawable/ic_notification';

enum NotificationAction {
  openMileage,
  postpone,
  openApp,
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  factory NotificationService() => instance;

  final _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Имя и описание канала, заданные при [init].
  String _channelName = '';
  String _channelDescription = '';

  final ValueNotifier<int> openMileageRequests = ValueNotifier<int>(0);

  bool pendingOpenMileage = false;

  void Function(NotificationAction)? onAction;

  static bool get _isSupported => Platform.isAndroid || Platform.isIOS;

  Future<void> init({
    required String channelName,
    required String channelDescription,
  }) async {
    if (_initialized) return;
    if (!_isSupported) return;
    _initialized = true;

    _channelName = channelName;
    _channelDescription = channelDescription;

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

    if (Platform.isAndroid && channelName.isNotEmpty) {
      await _createChannel(channelName, channelDescription);
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
    await service.init(channelName: '', channelDescription: '');
    return service;
  }

  /// Проверить, выдано ли разрешение на уведомления (без показа диалога).
  Future<bool> hasPermission() async {
    if (!_isSupported) return true;

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return false;
      return await android.areNotificationsEnabled() ?? false;
    }

    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios == null) return false;
      final permissions = await ios.checkPermissions();
      return permissions?.isEnabled ?? false;
    }

    return true;
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
    required NotificationTexts texts,
    int id = _mileageReminderId,
  }) async {
    if (!_isSupported || !_initialized) return;

    await _plugin.show(
      id,
      texts.title,
      texts.body,
      _notificationDetails(texts),
      payload: _payloadMileageReminder,
    );
  }

  Future<void> scheduleMileageReminder({
    required NotificationTexts texts,
    required DateTime when,
    int id = _mileageReminderId,
  }) async {
    if (!_isSupported || !_initialized) return;
    if (when.isBefore(DateTime.now())) return;

    final scheduled = tz.TZDateTime.from(when, tz.local);

    await _plugin.zonedSchedule(
      id,
      texts.title,
      texts.body,
      scheduled,
      _notificationDetails(texts),
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

  NotificationDetails _notificationDetails(NotificationTexts texts) {
    return NotificationDetails(
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
            texts.actionUpdate,
            showsUserInterface: true,
          ),
          AndroidNotificationAction(
            _actionLater,
            texts.actionLater,
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future<void> _createChannel(
    String name,
    String description,
  ) async {
    if (!_isSupported) return;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _channelId,
        name,
        description: description,
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
      pendingOpenMileage = true;
      openMileageRequests.value++;
      onAction?.call(NotificationAction.openMileage);
      return;
    }

    if (actionId == _actionLater) {
      onAction?.call(NotificationAction.postpone);
      return;
    }

    onAction?.call(NotificationAction.openApp);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundResponse(NotificationResponse response) {
    debugPrint('Background notification action: ${response.actionId}');
  }
}
