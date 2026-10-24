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

  /// No description provided for @onboardingWelcome.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать'**
  String get onboardingWelcome;

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
  /// **'Typical works'**
  String get templatePickerTitle;

  /// No description provided for @templateCustom.
  ///
  /// In ru, this message translates to:
  /// **'Custom'**
  String get templateCustom;

  /// No description provided for @templateIntervalNotSet.
  ///
  /// In ru, this message translates to:
  /// **'interval not set'**
  String get templateIntervalNotSet;

  /// No description provided for @templateIntervalEveryKm.
  ///
  /// In ru, this message translates to:
  /// **'every {km} km'**
  String templateIntervalEveryKm({required String km});

  /// No description provided for @templateIntervalEveryMonths.
  ///
  /// In ru, this message translates to:
  /// **'every {months} mo'**
  String templateIntervalEveryMonths({required int months});

  /// No description provided for @templateIntervalEveryKmMonths.
  ///
  /// In ru, this message translates to:
  /// **'every {km} km · {months} mo'**
  String templateIntervalEveryKmMonths(
      {required String km, required int months});

  /// No description provided for @confirmCancelTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отменить ТО?'**
  String get confirmCancelTitle;

  /// No description provided for @confirmCancelMessage.
  ///
  /// In ru, this message translates to:
  /// **'Работа «{ruleTitle}» будет помечена как отменённая. Она попадёт в историю со значком отмены и не будет считаться выполненной. Следующее ТО сдвинется на текущий пробег.'**
  String confirmCancelMessage({required String ruleTitle});

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

  /// No description provided for @updateMileageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег'**
  String get updateMileageTitle;

  /// No description provided for @updateMileageFieldLabel.
  ///
  /// In ru, this message translates to:
  /// **'Новый пробег'**
  String get updateMileageFieldLabel;

  /// No description provided for @updateMileageUnitKm.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get updateMileageUnitKm;

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

  /// No description provided for @mileageErrorRequired.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get mileageErrorRequired;

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

  /// No description provided for @editRuleNextKmUnit.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get editRuleNextKmUnit;

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

  /// No description provided for @editRuleIntervalKmUnit.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get editRuleIntervalKmUnit;

  /// No description provided for @editRuleIntervalMonthsLabel.
  ///
  /// In ru, this message translates to:
  /// **'По месяцам'**
  String get editRuleIntervalMonthsLabel;

  /// No description provided for @editRuleIntervalMonthsUnit.
  ///
  /// In ru, this message translates to:
  /// **'мес'**
  String get editRuleIntervalMonthsUnit;

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

  /// No description provided for @editRuleCostUnit.
  ///
  /// In ru, this message translates to:
  /// **'₽'**
  String get editRuleCostUnit;

  /// No description provided for @editRuleNoteLabel.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get editRuleNoteLabel;

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

  /// No description provided for @validationRequired.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get validationRequired;

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

  /// No description provided for @historyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено'**
  String get historyTitle;

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

  /// No description provided for @historyHowItWorks.
  ///
  /// In ru, this message translates to:
  /// **'Как это работает?'**
  String get historyHowItWorks;

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

  /// No description provided for @historyCardMileage.
  ///
  /// In ru, this message translates to:
  /// **'{km} км'**
  String historyCardMileage({required String km});

  /// No description provided for @historyCardCost.
  ///
  /// In ru, this message translates to:
  /// **'{amount} ₽'**
  String historyCardCost({required String amount});

  /// No description provided for @historyCardEditTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get historyCardEditTooltip;

  /// No description provided for @historyCardDeleteTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get historyCardDeleteTooltip;

  /// No description provided for @homeCarNameFallback.
  ///
  /// In ru, this message translates to:
  /// **'Мой автомобиль'**
  String get homeCarNameFallback;

  /// No description provided for @homeSelectionCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get homeSelectionCancel;

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

  /// No description provided for @homeHowItWorks.
  ///
  /// In ru, this message translates to:
  /// **'Как это работает?'**
  String get homeHowItWorks;

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

  /// No description provided for @dueCardKmLeft.
  ///
  /// In ru, this message translates to:
  /// **'{km} км'**
  String dueCardKmLeft({required String km});

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

  /// No description provided for @dueDaysShort.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String dueDaysShort({required int count});

  /// No description provided for @dueMonthsShort.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} мес} few{{count} мес} many{{count} мес} other{{count} мес}}'**
  String dueMonthsShort({required int count});

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

  /// No description provided for @mileageHeaderUnitKm.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get mileageHeaderUnitKm;

  /// No description provided for @mileageHeaderUpdateButton.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег'**
  String get mileageHeaderUpdateButton;

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

  /// No description provided for @nearestDueKm.
  ///
  /// In ru, this message translates to:
  /// **'{km} км'**
  String nearestDueKm({required String km});

  /// No description provided for @nearestDueDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String nearestDueDays({required int count});

  /// No description provided for @nearestDueMonths.
  ///
  /// In ru, this message translates to:
  /// **'{count} мес'**
  String nearestDueMonths({required int count});

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

  /// No description provided for @settingsTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTooltip;

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

  /// No description provided for @markDoneMultiMileageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пробег выполнения'**
  String get markDoneMultiMileageLabel;

  /// No description provided for @markDoneMultiMileageUnit.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get markDoneMultiMileageUnit;

  /// No description provided for @markDoneMultiMonthLabel.
  ///
  /// In ru, this message translates to:
  /// **'Месяц выполнения'**
  String get markDoneMultiMonthLabel;

  /// No description provided for @markDoneMultiNoteLabel.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get markDoneMultiNoteLabel;

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

  /// No description provided for @markDoneMultiUpdateMileageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег машины?'**
  String get markDoneMultiUpdateMileageTitle;

  /// No description provided for @markDoneMultiUpdateMileageMessage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег: {current} км.\nПробег выполнения: {performed} км.\n\nОбновить текущий пробег машины до {performed} км?'**
  String markDoneMultiUpdateMileageMessage(
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

  /// No description provided for @markDoneMileageUnit.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get markDoneMileageUnit;

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

  /// No description provided for @markDoneCostUnit.
  ///
  /// In ru, this message translates to:
  /// **'₽'**
  String get markDoneCostUnit;

  /// No description provided for @markDoneNoteLabel.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get markDoneNoteLabel;

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

  /// No description provided for @markDoneJumpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пробег резко вырос'**
  String get markDoneJumpTitle;

  /// No description provided for @markDoneJumpMessage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег машины: {current} км.\nВы отметили ТО на {performed} км.\n\nРазница: {diff} км. Обычно столько не проезжают между обновлениями. Проверьте, не лишний ли ноль.'**
  String markDoneJumpMessage(
      {required String current,
      required String performed,
      required String diff});

  /// No description provided for @markDoneJumpEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get markDoneJumpEdit;

  /// No description provided for @markDoneJumpConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Да, верно'**
  String get markDoneJumpConfirm;

  /// No description provided for @markDoneUpdateMileageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег машины?'**
  String get markDoneUpdateMileageTitle;

  /// No description provided for @markDoneUpdateMileageMessage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег: {current} км.\nПробег выполнения: {performed} км.\n\nОбновить текущий пробег машины до {performed} км?'**
  String markDoneUpdateMileageMessage(
      {required String current, required String performed});
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
