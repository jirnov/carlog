// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vehicle Maintenance Log';

  @override
  String get workCategoryEngine => 'Engine';

  @override
  String get workCategoryTransmission => 'Transmission';

  @override
  String get workCategoryAwd => 'All-wheel drive';

  @override
  String get workCategoryBrakes => 'Brakes';

  @override
  String get workCategoryInterior => 'Interior';

  @override
  String get workEngineOilChange => 'Engine oil change';

  @override
  String get workAirFilterReplace => 'Air filter replacement';

  @override
  String get workFuelFilterReplace => 'Fuel filter replacement';

  @override
  String get workSparkPlugReplace => 'Spark plug replacement';

  @override
  String get workTimingBeltReplace => 'Timing belt replacement';

  @override
  String get workAntifreezeReplace => 'Antifreeze replacement';

  @override
  String get workMtmOilChange => 'Manual transmission oil change';

  @override
  String get workAtmOilChange => 'Automatic transmission oil change';

  @override
  String get workCvtOilChange => 'CVT transmission oil change';

  @override
  String get workHaldexOilChange => 'Haldex oil change';

  @override
  String get workTransferCaseOilChange => 'Transfer case oil change';

  @override
  String get workTransferCaseOilChangeSubtitle => 'xDrive / 4Matic / quattro';

  @override
  String get workDifferentialOilChange => 'Differential oil change';

  @override
  String get workBrakeFluidReplace => 'Brake fluid replacement';

  @override
  String get workBrakePadReplace => 'Brake pad replacement';

  @override
  String get workBrakeDiscReplace => 'Brake disc replacement';

  @override
  String get workBrakeDrumReplace => 'Brake drum replacement';

  @override
  String get workCabinFilterReplace => 'Cabin filter replacement';

  @override
  String get templatePickerTitle => 'Typical works';

  @override
  String get templateCustom => 'Custom';

  @override
  String get templateIntervalNotSet => 'interval not set';

  @override
  String templateIntervalEveryKm({required String km}) {
    return 'every $km km';
  }

  @override
  String templateIntervalEveryMonths({required int months}) {
    return 'every $months mo';
  }

  @override
  String templateIntervalEveryKmMonths(
      {required String km, required int months}) {
    return 'every $km km · $months mo';
  }

  @override
  String get confirmCancelTitle => 'Cancel maintenance?';

  @override
  String confirmCancelMessage({required String ruleTitle}) {
    return 'Work “$ruleTitle” will be marked as cancelled. It will appear in history with a cancellation icon and will not be counted as completed. The next maintenance will be shifted to the current mileage.';
  }

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirmCancel => 'Cancel it';

  @override
  String get actionDelete => 'Delete';

  @override
  String get confirmExitTitle => 'Exit without saving?';

  @override
  String get confirmExitMessage => 'All changes will be lost';

  @override
  String get actionExit => 'Exit';

  @override
  String get postponeTitle => 'Postpone maintenance';

  @override
  String get postponePeriodQuestion => 'For how long?';

  @override
  String get postponeThreeDays => 'For 3 days';

  @override
  String get postponeOneWeek => 'For a week';

  @override
  String get postponeOneMonth => 'For a month';

  @override
  String get postponeCustom => 'Custom date';

  @override
  String get postponeDateLabel => 'Date';

  @override
  String get postponePickDate => 'Pick a date';

  @override
  String get actionPostpone => 'Postpone';

  @override
  String get updateMileageTitle => 'Update mileage';

  @override
  String get updateMileageFieldLabel => 'New mileage';

  @override
  String get updateMileageUnitKm => 'km';

  @override
  String updateMileagePrevious({required String km}) {
    return 'Previous: $km km';
  }

  @override
  String get updateMileageDateToday => 'Date: today';

  @override
  String get mileageErrorRequired => 'Required field';

  @override
  String get mileageErrorPositive => 'Mileage must be greater than zero';

  @override
  String mileageErrorMin({required String km}) {
    return 'Not less than $km km';
  }

  @override
  String get mileageErrorTooLarge => 'Value is too large';

  @override
  String get mileageJumpTitle => 'Mileage jumped sharply';

  @override
  String mileageJumpMessage(
      {required String previous,
      required String current,
      required String diff}) {
    return 'Previous mileage: $previous km.\nNew: $current km.\n\nDifference: $diff km at once. Usually people don\'t drive that much between updates. Check for an extra zero.';
  }

  @override
  String get mileageJumpEdit => 'Edit';

  @override
  String get mileageJumpConfirm => 'Yes, correct';

  @override
  String get actionSave => 'Save';

  @override
  String get editRuleTitleEdit => 'Edit scheduled maintenance';

  @override
  String get editRuleTitleNew => 'New scheduled maintenance';

  @override
  String get editRuleNameLabel => 'Name of scheduled work';

  @override
  String get editRuleNameHint =>
      'For example, automatic transmission oil change';

  @override
  String get editRuleNextKmLabel =>
      'At what mileage to do the next maintenance';

  @override
  String get editRuleNextKmUnit => 'km';

  @override
  String editRuleNextKmWarning({required String km}) {
    return 'Less than current mileage ($km km). The maintenance may already be done.';
  }

  @override
  String get editRuleIntervalSection => 'Interval';

  @override
  String get editRuleIntervalKmLabel => 'By km';

  @override
  String get editRuleIntervalKmUnit => 'km';

  @override
  String get editRuleIntervalMonthsLabel => 'By months';

  @override
  String get editRuleIntervalMonthsUnit => 'mo';

  @override
  String get editRuleIntervalError => 'Fill in at least one interval';

  @override
  String get editRuleCostLabel => 'Estimated cost';

  @override
  String get editRuleCostHint =>
      'For statistics and expense planning (optional)';

  @override
  String get editRuleCostUnit => '₽';

  @override
  String get editRuleNoteLabel => 'Note';

  @override
  String get editRuleNoteHint => 'For example, synthetic oil';

  @override
  String get editRuleNextDateLabel => 'Next maintenance date';

  @override
  String get editRuleNextDateNone => 'Not set';

  @override
  String get editRuleResetDate => 'Reset';

  @override
  String get validationRequired => 'Required field';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpLoadError => 'Failed to load help';

  @override
  String helpMailSubject({required String version}) {
    return 'Suggestions for the Maintenance Log (version $version)';
  }

  @override
  String get historyTitle => 'Completed';

  @override
  String get historyAddTooltip => 'Add event';

  @override
  String get historyEmptyTitle => 'History is empty';

  @override
  String get historyEmptyMessage =>
      'Completed works will appear here\nBut you can add them manually';

  @override
  String get historyHowItWorks => 'How does it work?';

  @override
  String historyDeleteTitle({required String title}) {
    return 'Delete work “$title”?';
  }

  @override
  String get historyDeleteMessage => 'The record will be deleted from history.';

  @override
  String historyCardMileage({required String km}) {
    return '$km km';
  }

  @override
  String historyCardCost({required String amount}) {
    return '$amount ₽';
  }

  @override
  String get historyCardEditTooltip => 'Edit';

  @override
  String get historyCardDeleteTooltip => 'Delete';

  @override
  String get homeCarNameFallback => 'My car';

  @override
  String get homeSelectionCancel => 'Cancel';

  @override
  String homeSelectionCount({required int count}) {
    return 'Selected: $count';
  }

  @override
  String get homePostponedSection => 'Postponed';

  @override
  String homeMarkDoneSelected({required int count}) {
    return 'Complete ($count)';
  }

  @override
  String get homeEmptyTitle => 'Work schedule is empty';

  @override
  String get homeEmptyMessage =>
      'Add scheduled maintenance on the “Schedule” tab';

  @override
  String get homeHowItWorks => 'How does it work?';

  @override
  String homeDoneSelectedSnack(
      {required int count, required String km, required String date}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count works',
      one: '1 work',
    );
    return '$_temp0 completed — $km km, $date';
  }

  @override
  String homeDoneSingleSnack(
      {required String title, required String km, required String date}) {
    return '$title completed — $km km, $date';
  }

  @override
  String dueCardPostponedUntil({required String date}) {
    return 'Postponed until $date';
  }

  @override
  String dueCardNext({required String value}) {
    return 'Next: $value';
  }

  @override
  String dueCardLeft({required String value}) {
    return 'Left: $value';
  }

  @override
  String dueCardOverdueKm({required String km}) {
    return 'overdue by $km km';
  }

  @override
  String dueCardOverdueDays({required String value}) {
    return 'overdue by $value';
  }

  @override
  String dueCardKmLeft({required String km}) {
    return '$km km';
  }

  @override
  String get dueCardActionPostpone => '[Postpone]';

  @override
  String get dueCardActionMarkDone => '[Complete]';

  @override
  String dueDaysShort({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String dueMonthsShort({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mo',
      one: '$count mo',
    );
    return '$_temp0';
  }

  @override
  String get mileageHeaderNotSet => 'Mileage not set';

  @override
  String get mileageHeaderUpdatedToday => 'Updated today';

  @override
  String get mileageHeaderUpdatedYesterday => 'Updated yesterday';

  @override
  String mileageHeaderUpdatedDaysAgo({required int days}) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return 'Updated $days $_temp0 ago';
  }

  @override
  String get mileageHeaderStaleSuffix => 'update';

  @override
  String get mileageHeaderUnitKm => 'km';

  @override
  String get mileageHeaderUpdateButton => 'Update mileage';

  @override
  String nearestDueOverdue({required String value}) {
    return 'Overdue: $value';
  }

  @override
  String nearestDueSoon({required String value}) {
    return 'Next maintenance in $value';
  }

  @override
  String nearestDueKm({required String km}) {
    return '$km km';
  }

  @override
  String nearestDueDays({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String nearestDueMonths({required int count}) {
    return '$count mo';
  }

  @override
  String get navSchedule => 'Work schedule';

  @override
  String get navPlanning => 'Planning';

  @override
  String get navHistory => 'Completed';

  @override
  String get exitConfirmMessage => 'Press again to exit';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String markDoneMultiTitle({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count works',
      one: '$count work',
    );
    return 'Complete $_temp0';
  }

  @override
  String get markDoneMultiWorksSection => 'Works';

  @override
  String get markDoneMultiMileageLabel => 'Completion mileage';

  @override
  String get markDoneMultiMileageUnit => 'km';

  @override
  String get markDoneMultiMonthLabel => 'Completion month';

  @override
  String get markDoneMultiNoteLabel => 'Note';

  @override
  String get markDoneMultiNoteHint => 'For example, service on Lenin St.';

  @override
  String markDoneMultiSaveButton({required int count}) {
    return 'Complete $count';
  }

  @override
  String get markDoneMultiUpdateMileageTitle => 'Update car mileage?';

  @override
  String markDoneMultiUpdateMileageMessage(
      {required String current, required String performed}) {
    return 'Current mileage: $current km.\nCompletion mileage: $performed km.\n\nUpdate the current car mileage to $performed km?';
  }

  @override
  String get actionNo => 'No';

  @override
  String get actionYes => 'Yes';

  @override
  String get markDoneTitleEdit => 'Edit event';

  @override
  String get markDoneTitleRule => 'Complete work';

  @override
  String get markDoneTitleAdd => 'Add event';

  @override
  String get markDoneWorkLabel => 'Work';

  @override
  String get markDoneWorkHint => 'For example, replaced a bulb';

  @override
  String get markDoneMileageLabel => 'Completion mileage';

  @override
  String get markDoneMileageUnit => 'km';

  @override
  String get markDoneMonthLabel => 'Completion month';

  @override
  String get markDoneCostLabel => 'Cost';

  @override
  String get markDoneCostHint => 'Optional';

  @override
  String get markDoneCostUnit => '₽';

  @override
  String get markDoneNoteLabel => 'Note';

  @override
  String get markDoneNoteHint => 'For example, synthetic oil';

  @override
  String get mileageErrorTooSmall =>
      'Mileage looks suspiciously small — check the value';

  @override
  String get markDoneJumpTitle => 'Mileage jumped sharply';

  @override
  String markDoneJumpMessage(
      {required String current,
      required String performed,
      required String diff}) {
    return 'Current car mileage: $current km.\nYou marked maintenance at $performed km.\n\nDifference: $diff km. Usually people don\'t drive that much between updates. Check for an extra zero.';
  }

  @override
  String get markDoneJumpEdit => 'Edit';

  @override
  String get markDoneJumpConfirm => 'Yes, correct';

  @override
  String get markDoneUpdateMileageTitle => 'Update car mileage?';

  @override
  String markDoneUpdateMileageMessage(
      {required String current, required String performed}) {
    return 'Current mileage: $current km.\nCompletion mileage: $performed km.\n\nUpdate the current car mileage to $performed km?';
  }

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeSubtitle =>
      'A couple of questions so the app\ncan calculate maintenance intervals right away';

  @override
  String get onboardingCarNameLabel => 'Car name';

  @override
  String get onboardingCarNameHint => 'For example, My swallow';

  @override
  String get onboardingCarNameHelper => 'Optional';

  @override
  String get onboardingMileageLabel => 'Current mileage';

  @override
  String get onboardingMileageUnit => 'km';

  @override
  String get onboardingMileageRequired => 'Required field';

  @override
  String get onboardingThemeTitle => 'Theme';

  @override
  String get onboardingThemeHint => 'You can change it later in settings';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String onboardingSaveError({required String error}) {
    return 'Failed to save: $error';
  }

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeDialogTitle => 'Appearance theme';

  @override
  String get rulesTitle => 'Planning';

  @override
  String get rulesAddTooltip => 'Add rule';

  @override
  String get rulesEmptyTitle => 'No plans yet';

  @override
  String get rulesEmptyMessage =>
      'Add a scheduled maintenance with an interval\nand it will appear in the work schedule';

  @override
  String get rulesHowToStart => 'Where to start?';

  @override
  String rulesDeleteTitle({required String title}) {
    return 'Delete rule “$title”?';
  }

  @override
  String get rulesDeleteMessage =>
      'The history of completed works will not change.';

  @override
  String get ruleCardIntervalNotSet => 'interval not set';

  @override
  String ruleCardIntervalKm({required String km}) {
    return '$km km';
  }

  @override
  String ruleCardIntervalMonths({required int months}) {
    return '$months mo';
  }

  @override
  String ruleCardEveryOne({required String value}) {
    return 'Every $value';
  }

  @override
  String ruleCardEveryTwo({required String first, required String second}) {
    return 'Every $first or $second';
  }

  @override
  String ruleCardNextOne({required String value}) {
    return 'Next: $value';
  }

  @override
  String ruleCardNextTwo({required String first, required String second}) {
    return 'Next: $first · $second';
  }

  @override
  String get ruleCardNextNotSet => 'Next maintenance not set';

  @override
  String ruleCardCost({required String amount}) {
    return '~$amount ₽';
  }

  @override
  String get ruleCardEditTooltip => 'Edit';

  @override
  String get ruleCardDeleteTooltip => 'Delete';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionCar => 'Car';

  @override
  String get settingsSectionReminders => 'Mileage reminders';

  @override
  String get settingsSectionThresholds => 'Warning thresholds';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionSupport => 'Help and support';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsCarNameTitle => 'Name';

  @override
  String get settingsCarNameNotSet => 'Not set';

  @override
  String get settingsCarNameDialogTitle => 'Car name';

  @override
  String get settingsCarNameHint => 'For example, My swallow';

  @override
  String get settingsRemindEnabled => 'Remind to update mileage';

  @override
  String get settingsRemindDaysTitle => 'How often';

  @override
  String get settingsRemindDaysDialogTitle => 'Remind every';

  @override
  String get settingsRemindDaysUnit => 'days';

  @override
  String settingsRemindDaysValue({required int days}) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$days $_temp0';
  }

  @override
  String get settingsYellowKmTitle => 'How many km before';

  @override
  String get settingsYellowKmDialogTitle => 'Warning threshold by km';

  @override
  String get settingsYellowKmUnit => 'km';

  @override
  String settingsYellowKmValue({required String km}) {
    return '$km km';
  }

  @override
  String get settingsYellowMonthsTitle => 'How many months before';

  @override
  String get settingsYellowMonthsDialogTitle => 'Warning threshold by time';

  @override
  String get settingsYellowMonthsUnit => 'mo';

  @override
  String settingsYellowMonthsValue({required int months}) {
    return '$months mo';
  }

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsExportTitle => 'Export data';

  @override
  String get settingsExportSubtitle => 'Save everything to a JSON file';

  @override
  String get settingsExportSubject => 'Maintenance Log — backup';

  @override
  String get settingsExportFailed => 'Failed to save file';

  @override
  String settingsExportSaved({required String path}) {
    return 'File saved: $path';
  }

  @override
  String get settingsImportTitle => 'Import data';

  @override
  String get settingsImportSubtitle => 'Load from a JSON file';

  @override
  String get settingsImportConfirmTitle => 'Import data?';

  @override
  String get settingsImportConfirmMessage =>
      'All current data will be replaced with the file contents.';

  @override
  String get settingsImportConfirmAction => 'Import';

  @override
  String get settingsImportWrongExtension =>
      'Choose a file with the .json extension';

  @override
  String get settingsImportFailed => 'Failed to import file';

  @override
  String get settingsImportSuccess => 'Data imported';

  @override
  String get settingsRestoreTitle => 'Restore from backup';

  @override
  String get settingsRestoreSubtitle => 'Automatic backups';

  @override
  String get settingsRestoreConfirmTitle => 'Restore from backup?';

  @override
  String get settingsRestoreConfirmMessage =>
      'All current data will be replaced with the backup contents.';

  @override
  String get settingsRestoreConfirmAction => 'Restore';

  @override
  String get settingsRestoreFailed => 'Failed to restore backup';

  @override
  String get settingsRestoreSuccess => 'Data restored from backup';

  @override
  String get settingsRestoreEmpty => 'No backups yet';

  @override
  String settingsBackupSizeBytes({required int size}) {
    return '$size B';
  }

  @override
  String settingsBackupSizeKb({required String size}) {
    return '$size KB';
  }

  @override
  String get settingsHelpTitle => 'Help';

  @override
  String get settingsHelpSubtitle => 'How to use the app';

  @override
  String get settingsShareTitle => 'Share the app';

  @override
  String get settingsShareSubtitle => 'Send a store link';

  @override
  String settingsShareText({required String appName, required String url}) {
    return 'Try the “$appName” app — a car maintenance diary.\n\n$url';
  }

  @override
  String get settingsCoffeeTitle => 'Buy the author a coffee';

  @override
  String get settingsCoffeeSubtitle => 'Support development';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get splashLoadError => 'Failed to load data';

  @override
  String get splashRetry => 'Retry';
}
