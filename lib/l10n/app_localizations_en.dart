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
  String get onboardingWelcome => 'Welcome';

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
}
