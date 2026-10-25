import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Журнал ТО'**
  String get appTitle;

  /// No description provided for @languageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get languageTitle;

  /// No description provided for @languageDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык приложения'**
  String get languageDialogTitle;

  /// No description provided for @languageSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get languageSystem;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @workCategoryEngine.
  ///
  /// In ru, this message translates to:
  /// **'Двигатель'**
  String get workCategoryEngine;

  /// No description provided for @workCategoryTransmission.
  ///
  /// In ru, this message translates to:
  /// **'Трансмиссия'**
  String get workCategoryTransmission;

  /// No description provided for @workCategoryAwd.
  ///
  /// In ru, this message translates to:
  /// **'Полный привод'**
  String get workCategoryAwd;

  /// No description provided for @workCategoryBrakes.
  ///
  /// In ru, this message translates to:
  /// **'Тормоза'**
  String get workCategoryBrakes;

  /// No description provided for @workCategoryInterior.
  ///
  /// In ru, this message translates to:
  /// **'Салон'**
  String get workCategoryInterior;

  /// No description provided for @workEngineOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в двигателе'**
  String get workEngineOilChange;

  /// No description provided for @workAirFilterReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена воздушного фильтра'**
  String get workAirFilterReplace;

  /// No description provided for @workFuelFilterReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена топливного фильтра'**
  String get workFuelFilterReplace;

  /// No description provided for @workSparkPlugReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена свечей зажигания'**
  String get workSparkPlugReplace;

  /// No description provided for @workTimingBeltReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена ГРМ'**
  String get workTimingBeltReplace;

  /// No description provided for @workAntifreezeReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена антифриза'**
  String get workAntifreezeReplace;

  /// No description provided for @workMtmOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в МКПП'**
  String get workMtmOilChange;

  /// No description provided for @workAtmOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в АКПП'**
  String get workAtmOilChange;

  /// No description provided for @workCvtOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в вариаторе (CVT)'**
  String get workCvtOilChange;

  /// No description provided for @workHaldexOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в Haldex'**
  String get workHaldexOilChange;

  /// No description provided for @workTransferCaseOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в раздатке'**
  String get workTransferCaseOilChange;

  /// No description provided for @workTransferCaseOilChangeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'xDrive / 4Matic / quattro'**
  String get workTransferCaseOilChangeSubtitle;

  /// No description provided for @workDifferentialOilChange.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла в редукторе'**
  String get workDifferentialOilChange;

  /// No description provided for @workBrakeFluidReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена тормозной жидкости'**
  String get workBrakeFluidReplace;

  /// No description provided for @workBrakePadReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена тормозных колодок'**
  String get workBrakePadReplace;

  /// No description provided for @workBrakeDiscReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена тормозных дисков'**
  String get workBrakeDiscReplace;

  /// No description provided for @workBrakeDrumReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена тормозных барабанов'**
  String get workBrakeDrumReplace;

  /// No description provided for @workCabinFilterReplace.
  ///
  /// In ru, this message translates to:
  /// **'Замена салонного фильтра'**
  String get workCabinFilterReplace;

  /// No description provided for @templatePickerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Типовые работы'**
  String get templatePickerTitle;

  /// No description provided for @templateCustom.
  ///
  /// In ru, this message translates to:
  /// **'Своё'**
  String get templateCustom;

  /// No description provided for @intervalNotSet.
  ///
  /// In ru, this message translates to:
  /// **'интервал не задан'**
  String get intervalNotSet;

  /// No description provided for @templateIntervalEveryKm.
  ///
  /// In ru, this message translates to:
  /// **'каждые {km} км'**
  String templateIntervalEveryKm({required String km});

  /// No description provided for @templateIntervalEveryMonths.
  ///
  /// In ru, this message translates to:
  /// **'каждые {months} мес'**
  String templateIntervalEveryMonths({required int months});

  /// No description provided for @templateIntervalEveryKmMonths.
  ///
  /// In ru, this message translates to:
  /// **'каждые {km} км · {months} мес'**
  String templateIntervalEveryKmMonths(
      {required String km, required int months});

  /// No description provided for @actionCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get actionCancel;

  /// No description provided for @actionConfirmCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отменить'**
  String get actionConfirmCancel;

  /// No description provided for @actionDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get actionEdit;

  /// No description provided for @confirmExitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти без сохранения?'**
  String get confirmExitTitle;

  /// No description provided for @confirmExitMessage.
  ///
  /// In ru, this message translates to:
  /// **'Все изменения будут утеряны'**
  String get confirmExitMessage;

  /// No description provided for @actionExit.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get actionExit;

  /// No description provided for @postponeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отложить ТО'**
  String get postponeTitle;

  /// No description provided for @postponePeriodQuestion.
  ///
  /// In ru, this message translates to:
  /// **'На какой срок?'**
  String get postponePeriodQuestion;

  /// No description provided for @postponeThreeDays.
  ///
  /// In ru, this message translates to:
  /// **'На 3 дня'**
  String get postponeThreeDays;

  /// No description provided for @postponeOneWeek.
  ///
  /// In ru, this message translates to:
  /// **'На неделю'**
  String get postponeOneWeek;

  /// No description provided for @postponeOneMonth.
  ///
  /// In ru, this message translates to:
  /// **'На месяц'**
  String get postponeOneMonth;

  /// No description provided for @postponeCustom.
  ///
  /// In ru, this message translates to:
  /// **'Свой срок'**
  String get postponeCustom;

  /// No description provided for @postponeDateLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get postponeDateLabel;

  /// No description provided for @postponePickDate.
  ///
  /// In ru, this message translates to:
  /// **'Выберите дату'**
  String get postponePickDate;

  /// No description provided for @actionPostpone.
  ///
  /// In ru, this message translates to:
  /// **'Отложить'**
  String get actionPostpone;

  /// No description provided for @actionUpdateMileage.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег'**
  String get actionUpdateMileage;

  /// No description provided for @updateMileageFieldLabel.
  ///
  /// In ru, this message translates to:
  /// **'Новый пробег'**
  String get updateMileageFieldLabel;

  /// No description provided for @unitKm.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get unitKm;

  /// No description provided for @updateMileagePrevious.
  ///
  /// In ru, this message translates to:
  /// **'Прошлый: {km} км'**
  String updateMileagePrevious({required String km});

  /// No description provided for @updateMileageDateToday.
  ///
  /// In ru, this message translates to:
  /// **'Дата: сегодня'**
  String get updateMileageDateToday;

  /// No description provided for @requiredField.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get requiredField;

  /// No description provided for @mileageErrorPositive.
  ///
  /// In ru, this message translates to:
  /// **'Пробег должен быть больше нуля'**
  String get mileageErrorPositive;

  /// No description provided for @mileageErrorMin.
  ///
  /// In ru, this message translates to:
  /// **'Не меньше {km} км'**
  String mileageErrorMin({required String km});

  /// No description provided for @mileageErrorTooLarge.
  ///
  /// In ru, this message translates to:
  /// **'Слишком большое значение'**
  String get mileageErrorTooLarge;

  /// No description provided for @mileageJumpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пробег резко вырос'**
  String get mileageJumpTitle;

  /// No description provided for @mileageJumpMessage.
  ///
  /// In ru, this message translates to:
  /// **'Прошлый пробег: {previous} км.\nНовый: {current} км.\n\nРазница: {diff} км за один раз. Обычно столько не проезжают между обновлениями. Проверьте, не лишний ли ноль.'**
  String mileageJumpMessage(
      {required String previous,
      required String current,
      required String diff});

  /// No description provided for @markDoneUpdateMileageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег машины?'**
  String get markDoneUpdateMileageTitle;

  /// No description provided for @markDoneJumpMessage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег машины: {current} км.\nВы отметили ТО на {performed} км.\n\nРазница: {diff} км. Обычно столько не проезжают между обновлениями. Проверьте, не лишний ли ноль.'**
  String markDoneJumpMessage(
      {required String current,
      required String performed,
      required String diff});

  /// No description provided for @mileageJumpEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get mileageJumpEdit;

  /// No description provided for @mileageJumpConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Да, верно'**
  String get mileageJumpConfirm;

  /// No description provided for @actionSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get actionSave;

  /// No description provided for @editRuleTitleEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить плановое ТО'**
  String get editRuleTitleEdit;

  /// No description provided for @editRuleTitleNew.
  ///
  /// In ru, this message translates to:
  /// **'Новое плановое ТО'**
  String get editRuleTitleNew;

  /// No description provided for @editRuleNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название регламентной работы'**
  String get editRuleNameLabel;

  /// No description provided for @editRuleNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, замена масла в АКПП'**
  String get editRuleNameHint;

  /// No description provided for @editRuleNextKmLabel.
  ///
  /// In ru, this message translates to:
  /// **'На каком пробеге делать следующее ТО'**
  String get editRuleNextKmLabel;

  /// No description provided for @editRuleNextKmWarning.
  ///
  /// In ru, this message translates to:
  /// **'Меньше текущего пробега ({km} км). Возможно, ТО уже выполнено.'**
  String editRuleNextKmWarning({required String km});

  /// No description provided for @editRuleIntervalSection.
  ///
  /// In ru, this message translates to:
  /// **'Интервал'**
  String get editRuleIntervalSection;

  /// No description provided for @editRuleIntervalKmLabel.
  ///
  /// In ru, this message translates to:
  /// **'По км'**
  String get editRuleIntervalKmLabel;

  /// No description provided for @editRuleIntervalMonthsLabel.
  ///
  /// In ru, this message translates to:
  /// **'По месяцам'**
  String get editRuleIntervalMonthsLabel;

  /// No description provided for @unitMonths.
  ///
  /// In ru, this message translates to:
  /// **'мес'**
  String get unitMonths;

  /// No description provided for @editRuleIntervalError.
  ///
  /// In ru, this message translates to:
  /// **'Заполните хотя бы один интервал'**
  String get editRuleIntervalError;

  /// No description provided for @editRuleCostLabel.
  ///
  /// In ru, this message translates to:
  /// **'Примерная стоимость'**
  String get editRuleCostLabel;

  /// No description provided for @editRuleCostHint.
  ///
  /// In ru, this message translates to:
  /// **'Для статистики и планирования расходов (необязательно)'**
  String get editRuleCostHint;

  /// No description provided for @unitCurrency.
  ///
  /// In ru, this message translates to:
  /// **'₽'**
  String get unitCurrency;

  /// No description provided for @noteLabel.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get noteLabel;

  /// No description provided for @editRuleNoteHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, синтетическое масло'**
  String get editRuleNoteHint;

  /// No description provided for @editRuleNextDateLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дата следующего ТО'**
  String get editRuleNextDateLabel;

  /// No description provided for @editRuleNextDateNone.
  ///
  /// In ru, this message translates to:
  /// **'Не указано'**
  String get editRuleNextDateNone;

  /// No description provided for @editRuleResetDate.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get editRuleResetDate;

  /// No description provided for @helpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Помощь'**
  String get helpTitle;

  /// No description provided for @helpLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить справку'**
  String get helpLoadError;

  /// No description provided for @helpMailSubject.
  ///
  /// In ru, this message translates to:
  /// **'Предложения по Журналу ТО (версия {version})'**
  String helpMailSubject({required String version});

  /// No description provided for @historyAddTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Добавить событие'**
  String get historyAddTooltip;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'История пуста'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся выполненные работы\nНо вы можете добавлять их самостоятельно'**
  String get historyEmptyMessage;

  /// No description provided for @historyDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить работу «{title}»?'**
  String historyDeleteTitle({required String title});

  /// No description provided for @historyDeleteMessage.
  ///
  /// In ru, this message translates to:
  /// **'Запись будет удалена из истории.'**
  String get historyDeleteMessage;

  /// No description provided for @historyCardCost.
  ///
  /// In ru, this message translates to:
  /// **'{amount} ₽'**
  String historyCardCost({required String amount});

  /// No description provided for @homeCarNameFallback.
  ///
  /// In ru, this message translates to:
  /// **'Мой автомобиль'**
  String get homeCarNameFallback;

  /// No description provided for @homeSelectionCount.
  ///
  /// In ru, this message translates to:
  /// **'Выбрано: {count}'**
  String homeSelectionCount({required int count});

  /// No description provided for @homePostponedSection.
  ///
  /// In ru, this message translates to:
  /// **'Отложенные'**
  String get homePostponedSection;

  /// No description provided for @homeMarkDoneSelected.
  ///
  /// In ru, this message translates to:
  /// **'Выполнить ({count})'**
  String homeMarkDoneSelected({required int count});

  /// No description provided for @homeEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'График работ пуст'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте плановое ТО на вкладке «Планирование»'**
  String get homeEmptyMessage;

  /// No description provided for @howItWorks.
  ///
  /// In ru, this message translates to:
  /// **'Как это работает?'**
  String get howItWorks;

  /// No description provided for @homeDoneSelectedSnack.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено {count, plural, =1{1 работа} few{{count} работы} many{{count} работ} other{{count} работы}} — {km} км, {date}'**
  String homeDoneSelectedSnack(
      {required int count, required String km, required String date});

  /// No description provided for @homeDoneSingleSnack.
  ///
  /// In ru, this message translates to:
  /// **'{title} выполнено — {km} км, {date}'**
  String homeDoneSingleSnack(
      {required String title, required String km, required String date});

  /// No description provided for @dueCardPostponedUntil.
  ///
  /// In ru, this message translates to:
  /// **'Отложено до {date}'**
  String dueCardPostponedUntil({required String date});

  /// No description provided for @dueCardNext.
  ///
  /// In ru, this message translates to:
  /// **'Следующее: {value}'**
  String dueCardNext({required String value});

  /// No description provided for @dueCardLeft.
  ///
  /// In ru, this message translates to:
  /// **'Осталось: {value}'**
  String dueCardLeft({required String value});

  /// No description provided for @dueCardOverdueKm.
  ///
  /// In ru, this message translates to:
  /// **'просрочено {km} км'**
  String dueCardOverdueKm({required String km});

  /// No description provided for @dueCardOverdueDays.
  ///
  /// In ru, this message translates to:
  /// **'просрочено {value}'**
  String dueCardOverdueDays({required String value});

  /// No description provided for @dueCardActionPostpone.
  ///
  /// In ru, this message translates to:
  /// **'[Отложить]'**
  String get dueCardActionPostpone;

  /// No description provided for @dueCardActionMarkDone.
  ///
  /// In ru, this message translates to:
  /// **'[Выполнить]'**
  String get dueCardActionMarkDone;

  /// No description provided for @mileageHeaderNotSet.
  ///
  /// In ru, this message translates to:
  /// **'Пробег не задан'**
  String get mileageHeaderNotSet;

  /// No description provided for @mileageHeaderUpdatedToday.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено сегодня'**
  String get mileageHeaderUpdatedToday;

  /// No description provided for @mileageHeaderUpdatedYesterday.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено вчера'**
  String get mileageHeaderUpdatedYesterday;

  /// No description provided for @mileageHeaderUpdatedDaysAgo.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено {days} {days, plural, one{день} few{дня} many{дней} other{дня}} назад'**
  String mileageHeaderUpdatedDaysAgo({required int days});

  /// No description provided for @mileageHeaderStaleSuffix.
  ///
  /// In ru, this message translates to:
  /// **'обновить'**
  String get mileageHeaderStaleSuffix;

  /// No description provided for @nearestDueOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Просрочено: {value}'**
  String nearestDueOverdue({required String value});

  /// No description provided for @nearestDueSoon.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшее ТО через {value}'**
  String nearestDueSoon({required String value});

  /// No description provided for @dayShort.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String dayShort({required int count});

  /// No description provided for @navSchedule.
  ///
  /// In ru, this message translates to:
  /// **'График работ'**
  String get navSchedule;

  /// No description provided for @navPlanning.
  ///
  /// In ru, this message translates to:
  /// **'Планирование'**
  String get navPlanning;

  /// No description provided for @navHistory.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено'**
  String get navHistory;

  /// No description provided for @exitConfirmMessage.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите ещё раз для выхода'**
  String get exitConfirmMessage;

  /// No description provided for @markDoneMultiTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выполнить {count, plural, one{{count} работу} few{{count} работы} many{{count} работ} other{{count} работы}}'**
  String markDoneMultiTitle({required int count});

  /// No description provided for @markDoneMultiWorksSection.
  ///
  /// In ru, this message translates to:
  /// **'Работы'**
  String get markDoneMultiWorksSection;

  /// No description provided for @markDoneMultiNoteHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, сервис на Ленина'**
  String get markDoneMultiNoteHint;

  /// No description provided for @markDoneMultiSaveButton.
  ///
  /// In ru, this message translates to:
  /// **'Выполнить {count}'**
  String markDoneMultiSaveButton({required int count});

  /// No description provided for @markDoneUpdateMileageMessage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег: {current} км.\nПробег выполнения: {performed} км.\n\nОбновить текущий пробег машины до {performed} км?'**
  String markDoneUpdateMileageMessage(
      {required String current, required String performed});

  /// No description provided for @actionNo.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get actionNo;

  /// No description provided for @actionYes.
  ///
  /// In ru, this message translates to:
  /// **'Да'**
  String get actionYes;

  /// No description provided for @markDoneTitleEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить событие'**
  String get markDoneTitleEdit;

  /// No description provided for @markDoneTitleRule.
  ///
  /// In ru, this message translates to:
  /// **'Выполнить работу'**
  String get markDoneTitleRule;

  /// No description provided for @markDoneTitleAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить событие'**
  String get markDoneTitleAdd;

  /// No description provided for @markDoneWorkLabel.
  ///
  /// In ru, this message translates to:
  /// **'Работа'**
  String get markDoneWorkLabel;

  /// No description provided for @markDoneWorkHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, поменял лампочку'**
  String get markDoneWorkHint;

  /// No description provided for @markDoneMileageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пробег выполнения'**
  String get markDoneMileageLabel;

  /// No description provided for @markDoneMonthLabel.
  ///
  /// In ru, this message translates to:
  /// **'Месяц выполнения'**
  String get markDoneMonthLabel;

  /// No description provided for @markDoneCostLabel.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get markDoneCostLabel;

  /// No description provided for @markDoneCostHint.
  ///
  /// In ru, this message translates to:
  /// **'Необязательно'**
  String get markDoneCostHint;

  /// No description provided for @markDoneNoteHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, синтетическое масло'**
  String get markDoneNoteHint;

  /// No description provided for @mileageErrorTooSmall.
  ///
  /// In ru, this message translates to:
  /// **'Пробег подозрительно мал — проверьте значение'**
  String get mileageErrorTooSmall;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Пара вопросов, чтобы приложение\nсразу считало сроки ТО'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingCarNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название машины'**
  String get onboardingCarNameLabel;

  /// No description provided for @onboardingCarNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Моя ласточка'**
  String get onboardingCarNameHint;

  /// No description provided for @onboardingCarNameHelper.
  ///
  /// In ru, this message translates to:
  /// **'Необязательно'**
  String get onboardingCarNameHelper;

  /// No description provided for @onboardingMileageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег'**
  String get onboardingMileageLabel;

  /// No description provided for @onboardingThemeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get onboardingThemeTitle;

  /// No description provided for @onboardingThemeHint.
  ///
  /// In ru, this message translates to:
  /// **'Можно изменить позже в настройках'**
  String get onboardingThemeHint;

  /// No description provided for @onboardingContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get onboardingContinue;

  /// No description provided for @onboardingSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить: {error}'**
  String onboardingSaveError({required String error});

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @themeDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тема оформления'**
  String get themeDialogTitle;

  /// No description provided for @rulesAddTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Добавить правило'**
  String get rulesAddTooltip;

  /// No description provided for @rulesEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Планов пока нет'**
  String get rulesEmptyTitle;

  /// No description provided for @rulesEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте плановое ТО с интервалом\nи оно появится в графике работ'**
  String get rulesEmptyMessage;

  /// No description provided for @rulesHowToStart.
  ///
  /// In ru, this message translates to:
  /// **'С чего начать?'**
  String get rulesHowToStart;

  /// No description provided for @rulesDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить правило «{title}»?'**
  String rulesDeleteTitle({required String title});

  /// No description provided for @rulesDeleteMessage.
  ///
  /// In ru, this message translates to:
  /// **'История выполненных работ не изменится.'**
  String get rulesDeleteMessage;

  /// No description provided for @kmWithValue.
  ///
  /// In ru, this message translates to:
  /// **'{km} км'**
  String kmWithValue({required String km});

  /// No description provided for @monthsWithValue.
  ///
  /// In ru, this message translates to:
  /// **'{months} мес'**
  String monthsWithValue({required int months});

  /// No description provided for @ruleCardEveryOne.
  ///
  /// In ru, this message translates to:
  /// **'Каждые {value}'**
  String ruleCardEveryOne({required String value});

  /// No description provided for @ruleCardEveryTwo.
  ///
  /// In ru, this message translates to:
  /// **'Каждые {first} или {second}'**
  String ruleCardEveryTwo({required String first, required String second});

  /// No description provided for @ruleCardNextOne.
  ///
  /// In ru, this message translates to:
  /// **'Следующее: {value}'**
  String ruleCardNextOne({required String value});

  /// No description provided for @ruleCardNextTwo.
  ///
  /// In ru, this message translates to:
  /// **'Следующее: {first} · {second}'**
  String ruleCardNextTwo({required String first, required String second});

  /// No description provided for @ruleCardNextNotSet.
  ///
  /// In ru, this message translates to:
  /// **'Следующее ТО не задано'**
  String get ruleCardNextNotSet;

  /// No description provided for @ruleCardCost.
  ///
  /// In ru, this message translates to:
  /// **'~{amount} ₽'**
  String ruleCardCost({required String amount});

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsSectionCar.
  ///
  /// In ru, this message translates to:
  /// **'Автомобиль'**
  String get settingsSectionCar;

  /// No description provided for @settingsSectionReminders.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания о пробеге'**
  String get settingsSectionReminders;

  /// No description provided for @settingsSectionThresholds.
  ///
  /// In ru, this message translates to:
  /// **'Пороги предупреждения'**
  String get settingsSectionThresholds;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Внешний вид'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionData.
  ///
  /// In ru, this message translates to:
  /// **'Данные'**
  String get settingsSectionData;

  /// No description provided for @settingsSectionSupport.
  ///
  /// In ru, this message translates to:
  /// **'Помощь и поддержка'**
  String get settingsSectionSupport;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsSectionAbout;

  /// No description provided for @settingsCarNameTitle.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get settingsCarNameTitle;

  /// No description provided for @settingsCarNameNotSet.
  ///
  /// In ru, this message translates to:
  /// **'Не задано'**
  String get settingsCarNameNotSet;

  /// No description provided for @settingsCarNameDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Название машины'**
  String get settingsCarNameDialogTitle;

  /// No description provided for @settingsCarNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Моя ласточка'**
  String get settingsCarNameHint;

  /// No description provided for @settingsRemindEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Напоминать об обновлении пробега'**
  String get settingsRemindEnabled;

  /// No description provided for @settingsRemindDaysTitle.
  ///
  /// In ru, this message translates to:
  /// **'Как часто'**
  String get settingsRemindDaysTitle;

  /// No description provided for @settingsRemindDaysDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Напоминать каждые'**
  String get settingsRemindDaysDialogTitle;

  /// No description provided for @settingsRemindDaysUnit.
  ///
  /// In ru, this message translates to:
  /// **'дней'**
  String get settingsRemindDaysUnit;

  /// No description provided for @settingsRemindDaysValue.
  ///
  /// In ru, this message translates to:
  /// **'{days} {days, plural, one{день} few{дня} many{дней} other{дня}}'**
  String settingsRemindDaysValue({required int days});

  /// No description provided for @settingsYellowKmTitle.
  ///
  /// In ru, this message translates to:
  /// **'За сколько км'**
  String get settingsYellowKmTitle;

  /// No description provided for @settingsYellowKmDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Порог предупреждения по км'**
  String get settingsYellowKmDialogTitle;

  /// No description provided for @settingsYellowMonthsTitle.
  ///
  /// In ru, this message translates to:
  /// **'За сколько месяцев'**
  String get settingsYellowMonthsTitle;

  /// No description provided for @settingsYellowMonthsDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Порог предупреждения по сроку'**
  String get settingsYellowMonthsDialogTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get settingsThemeTitle;

  /// No description provided for @settingsExportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт данных'**
  String get settingsExportTitle;

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить всё в JSON-файл'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsExportSubject.
  ///
  /// In ru, this message translates to:
  /// **'Журнал ТО — резервная копия'**
  String get settingsExportSubject;

  /// No description provided for @settingsExportFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить файл'**
  String get settingsExportFailed;

  /// No description provided for @settingsExportSaved.
  ///
  /// In ru, this message translates to:
  /// **'Файл сохранён: {path}'**
  String settingsExportSaved({required String path});

  /// No description provided for @settingsImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Импорт данных'**
  String get settingsImportTitle;

  /// No description provided for @settingsImportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить из JSON-файла'**
  String get settingsImportSubtitle;

  /// No description provided for @settingsImportConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Импортировать данные?'**
  String get settingsImportConfirmTitle;

  /// No description provided for @settingsImportConfirmMessage.
  ///
  /// In ru, this message translates to:
  /// **'Все текущие данные будут заменены содержимым файла.'**
  String get settingsImportConfirmMessage;

  /// No description provided for @settingsImportConfirmAction.
  ///
  /// In ru, this message translates to:
  /// **'Импортировать'**
  String get settingsImportConfirmAction;

  /// No description provided for @settingsImportWrongExtension.
  ///
  /// In ru, this message translates to:
  /// **'Выберите файл с расширением .json'**
  String get settingsImportWrongExtension;

  /// No description provided for @settingsImportFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось импортировать файл'**
  String get settingsImportFailed;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Данные импортированы'**
  String get settingsImportSuccess;

  /// No description provided for @settingsRestoreTitle.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить из архива'**
  String get settingsRestoreTitle;

  /// No description provided for @settingsRestoreSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Автоматические резервные копии'**
  String get settingsRestoreSubtitle;

  /// No description provided for @settingsRestoreConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить из архива?'**
  String get settingsRestoreConfirmTitle;

  /// No description provided for @settingsRestoreConfirmMessage.
  ///
  /// In ru, this message translates to:
  /// **'Все текущие данные будут заменены содержимым архива.'**
  String get settingsRestoreConfirmMessage;

  /// No description provided for @settingsRestoreConfirmAction.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить'**
  String get settingsRestoreConfirmAction;

  /// No description provided for @settingsRestoreFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось восстановить архив'**
  String get settingsRestoreFailed;

  /// No description provided for @settingsRestoreSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Данные восстановлены из архива'**
  String get settingsRestoreSuccess;

  /// No description provided for @settingsRestoreEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Архивных копий пока нет'**
  String get settingsRestoreEmpty;

  /// No description provided for @settingsBackupSizeBytes.
  ///
  /// In ru, this message translates to:
  /// **'{size} Б'**
  String settingsBackupSizeBytes({required int size});

  /// No description provided for @settingsBackupSizeKb.
  ///
  /// In ru, this message translates to:
  /// **'{size} КБ'**
  String settingsBackupSizeKb({required String size});

  /// No description provided for @settingsHelpSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Как пользоваться приложением'**
  String get settingsHelpSubtitle;

  /// No description provided for @settingsShareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться приложением'**
  String get settingsShareTitle;

  /// No description provided for @settingsShareSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Отправить ссылку на магазин'**
  String get settingsShareSubtitle;

  /// No description provided for @settingsShareText.
  ///
  /// In ru, this message translates to:
  /// **'Попробуй приложение «{appTitle}» — дневник обслуживания автомобиля.\n\n{url}'**
  String settingsShareText({required String appTitle, required String url});

  /// No description provided for @settingsCoffeeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Угостить автора бокалом кофе'**
  String get settingsCoffeeTitle;

  /// No description provided for @settingsCoffeeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Поддержать разработку'**
  String get settingsCoffeeSubtitle;

  /// No description provided for @settingsVersionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get settingsVersionTitle;

  /// No description provided for @splashLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить данные'**
  String get splashLoadError;

  /// No description provided for @splashRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get splashRetry;

  /// No description provided for @notificationChannelName.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание о пробеге'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In ru, this message translates to:
  /// **'Приложение просит обновить пробег машины'**
  String get notificationChannelDescription;

  /// No description provided for @notificationMileageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пора обновить пробег'**
  String get notificationMileageTitle;

  /// No description provided for @notificationMileageTitleWithCar.
  ///
  /// In ru, this message translates to:
  /// **'{carName}: пора обновить пробег'**
  String notificationMileageTitleWithCar({required String carName});

  /// No description provided for @notificationMileageBodyStale.
  ///
  /// In ru, this message translates to:
  /// **'Данные о пробеге устарели'**
  String get notificationMileageBodyStale;

  /// No description provided for @notificationMileageBodyOneDay.
  ///
  /// In ru, this message translates to:
  /// **'Данные устарели 1 день назад'**
  String get notificationMileageBodyOneDay;

  /// No description provided for @notificationMileageBodyDays.
  ///
  /// In ru, this message translates to:
  /// **'Данные устарели {days} {days, plural, one{день} few{дня} many{дней} other{дня}} назад'**
  String notificationMileageBodyDays({required int days});

  /// No description provided for @notificationActionUpdate.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get notificationActionUpdate;

  /// No description provided for @notificationActionLater.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get notificationActionLater;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
