// lib/services/notification_texts.dart

import 'package:carlog/l10n/app_localizations.dart';

class NotificationTexts {
  const NotificationTexts({
    required this.title,
    required this.body,
    required this.actionUpdate,
    required this.actionLater,
    required this.channelName,
    required this.channelDescription,
  });

  final String title;
  final String body;
  final String actionUpdate;
  final String actionLater;
  final String channelName;
  final String channelDescription;

  factory NotificationTexts.fromL10n(
    AppLocalizations l10n, {
    required String carName,
    required int daysSinceUpdate,
  }) {
    final title = carName.isEmpty
        ? l10n.notificationMileageTitle
        : l10n.notificationMileageTitleWithCar(carName: carName);

    final body = _body(l10n, daysSinceUpdate);

    return NotificationTexts(
      title: title,
      body: body,
      actionUpdate: l10n.notificationActionUpdate,
      actionLater: l10n.notificationActionLater,
      channelName: l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
    );
  }

  static String _body(AppLocalizations l10n, int days) {
    if (days <= 0) return l10n.notificationMileageBodyStale;
    if (days == 1) return l10n.notificationMileageBodyOneDay;
    return l10n.notificationMileageBodyDays(days: days);
  }
}