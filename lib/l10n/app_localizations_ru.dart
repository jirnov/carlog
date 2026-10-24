// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Журнал ТО';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageDialogTitle => 'Язык приложения';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get workCategoryEngine => 'Двигатель';

  @override
  String get workCategoryTransmission => 'Трансмиссия';

  @override
  String get workCategoryAwd => 'Полный привод';

  @override
  String get workCategoryBrakes => 'Тормоза';

  @override
  String get workCategoryInterior => 'Салон';

  @override
  String get workEngineOilChange => 'Замена масла в двигателе';

  @override
  String get workAirFilterReplace => 'Замена воздушного фильтра';

  @override
  String get workFuelFilterReplace => 'Замена топливного фильтра';

  @override
  String get workSparkPlugReplace => 'Замена свечей зажигания';

  @override
  String get workTimingBeltReplace => 'Замена ГРМ';

  @override
  String get workAntifreezeReplace => 'Замена антифриза';

  @override
  String get workMtmOilChange => 'Замена масла в МКПП';

  @override
  String get workAtmOilChange => 'Замена масла в АКПП';

  @override
  String get workCvtOilChange => 'Замена масла в вариаторе (CVT)';

  @override
  String get workHaldexOilChange => 'Замена масла в Haldex';

  @override
  String get workTransferCaseOilChange => 'Замена масла в раздатке';

  @override
  String get workTransferCaseOilChangeSubtitle => 'xDrive / 4Matic / quattro';

  @override
  String get workDifferentialOilChange => 'Замена масла в редукторе';

  @override
  String get workBrakeFluidReplace => 'Замена тормозной жидкости';

  @override
  String get workBrakePadReplace => 'Замена тормозных колодок';

  @override
  String get workBrakeDiscReplace => 'Замена тормозных дисков';

  @override
  String get workBrakeDrumReplace => 'Замена тормозных барабанов';

  @override
  String get workCabinFilterReplace => 'Замена салонного фильтра';

  @override
  String get templatePickerTitle => 'Типовые работы';

  @override
  String get templateCustom => 'Своё';

  @override
  String get intervalNotSet => 'интервал не задан';

  @override
  String templateIntervalEveryKm({required String km}) {
    return 'каждые $km км';
  }

  @override
  String templateIntervalEveryMonths({required int months}) {
    return 'каждые $months мес';
  }

  @override
  String templateIntervalEveryKmMonths(
      {required String km, required int months}) {
    return 'каждые $km км · $months мес';
  }

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionConfirmCancel => 'Отменить';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionEdit => 'Редактировать';

  @override
  String get confirmExitTitle => 'Выйти без сохранения?';

  @override
  String get confirmExitMessage => 'Все изменения будут утеряны';

  @override
  String get actionExit => 'Выйти';

  @override
  String get postponeTitle => 'Отложить ТО';

  @override
  String get postponePeriodQuestion => 'На какой срок?';

  @override
  String get postponeThreeDays => 'На 3 дня';

  @override
  String get postponeOneWeek => 'На неделю';

  @override
  String get postponeOneMonth => 'На месяц';

  @override
  String get postponeCustom => 'Свой срок';

  @override
  String get postponeDateLabel => 'Дата';

  @override
  String get postponePickDate => 'Выберите дату';

  @override
  String get actionPostpone => 'Отложить';

  @override
  String get actionUpdateMileage => 'Обновить пробег';

  @override
  String get updateMileageFieldLabel => 'Новый пробег';

  @override
  String get unitKm => 'км';

  @override
  String updateMileagePrevious({required String km}) {
    return 'Прошлый: $km км';
  }

  @override
  String get updateMileageDateToday => 'Дата: сегодня';

  @override
  String get requiredField => 'Обязательное поле';

  @override
  String get mileageErrorPositive => 'Пробег должен быть больше нуля';

  @override
  String mileageErrorMin({required String km}) {
    return 'Не меньше $km км';
  }

  @override
  String get mileageErrorTooLarge => 'Слишком большое значение';

  @override
  String get mileageJumpTitle => 'Пробег резко вырос';

  @override
  String mileageJumpMessage(
      {required String previous,
      required String current,
      required String diff}) {
    return 'Прошлый пробег: $previous км.\nНовый: $current км.\n\nРазница: $diff км за один раз. Обычно столько не проезжают между обновлениями. Проверьте, не лишний ли ноль.';
  }

  @override
  String markDoneJumpMessage(
      {required String current,
      required String performed,
      required String diff}) {
    return 'Текущий пробег машины: $current км.\nВы отметили ТО на $performed км.\n\nРазница: $diff км. Обычно столько не проезжают между обновлениями. Проверьте, не лишний ли ноль.';
  }

  @override
  String get mileageJumpEdit => 'Изменить';

  @override
  String get mileageJumpConfirm => 'Да, верно';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get editRuleTitleEdit => 'Изменить плановое ТО';

  @override
  String get editRuleTitleNew => 'Новое плановое ТО';

  @override
  String get editRuleNameLabel => 'Название регламентной работы';

  @override
  String get editRuleNameHint => 'Например, замена масла в АКПП';

  @override
  String get editRuleNextKmLabel => 'На каком пробеге делать следующее ТО';

  @override
  String editRuleNextKmWarning({required String km}) {
    return 'Меньше текущего пробега ($km км). Возможно, ТО уже выполнено.';
  }

  @override
  String get editRuleIntervalSection => 'Интервал';

  @override
  String get editRuleIntervalKmLabel => 'По км';

  @override
  String get editRuleIntervalMonthsLabel => 'По месяцам';

  @override
  String get unitMonths => 'мес';

  @override
  String get editRuleIntervalError => 'Заполните хотя бы один интервал';

  @override
  String get editRuleCostLabel => 'Примерная стоимость';

  @override
  String get editRuleCostHint =>
      'Для статистики и планирования расходов (необязательно)';

  @override
  String get unitCurrency => '₽';

  @override
  String get noteLabel => 'Заметка';

  @override
  String get editRuleNoteHint => 'Например, синтетическое масло';

  @override
  String get editRuleNextDateLabel => 'Дата следующего ТО';

  @override
  String get editRuleNextDateNone => 'Не указано';

  @override
  String get editRuleResetDate => 'Сбросить';

  @override
  String get helpTitle => 'Помощь';

  @override
  String get helpLoadError => 'Не удалось загрузить справку';

  @override
  String helpMailSubject({required String version}) {
    return 'Предложения по Журналу ТО (версия $version)';
  }

  @override
  String get historyAddTooltip => 'Добавить событие';

  @override
  String get historyEmptyTitle => 'История пуста';

  @override
  String get historyEmptyMessage =>
      'Здесь появятся выполненные работы\nНо вы можете добавлять их самостоятельно';

  @override
  String historyDeleteTitle({required String title}) {
    return 'Удалить работу «$title»?';
  }

  @override
  String get historyDeleteMessage => 'Запись будет удалена из истории.';

  @override
  String historyCardCost({required String amount}) {
    return '$amount ₽';
  }

  @override
  String get homeCarNameFallback => 'Мой автомобиль';

  @override
  String homeSelectionCount({required int count}) {
    return 'Выбрано: $count';
  }

  @override
  String get homePostponedSection => 'Отложенные';

  @override
  String homeMarkDoneSelected({required int count}) {
    return 'Выполнить ($count)';
  }

  @override
  String get homeEmptyTitle => 'График работ пуст';

  @override
  String get homeEmptyMessage =>
      'Добавьте плановое ТО на вкладке «Планирование»';

  @override
  String get howItWorks => 'Как это работает?';

  @override
  String homeDoneSelectedSnack(
      {required int count, required String km, required String date}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count работы',
      many: '$count работ',
      few: '$count работы',
      one: '1 работа',
    );
    return 'Выполнено $_temp0 — $km км, $date';
  }

  @override
  String homeDoneSingleSnack(
      {required String title, required String km, required String date}) {
    return '$title выполнено — $km км, $date';
  }

  @override
  String dueCardPostponedUntil({required String date}) {
    return 'Отложено до $date';
  }

  @override
  String dueCardNext({required String value}) {
    return 'Следующее: $value';
  }

  @override
  String dueCardLeft({required String value}) {
    return 'Осталось: $value';
  }

  @override
  String dueCardOverdueKm({required String km}) {
    return 'просрочено $km км';
  }

  @override
  String dueCardOverdueDays({required String value}) {
    return 'просрочено $value';
  }

  @override
  String get dueCardActionPostpone => '[Отложить]';

  @override
  String get dueCardActionMarkDone => '[Выполнить]';

  @override
  String get mileageHeaderNotSet => 'Пробег не задан';

  @override
  String get mileageHeaderUpdatedToday => 'Обновлено сегодня';

  @override
  String get mileageHeaderUpdatedYesterday => 'Обновлено вчера';

  @override
  String mileageHeaderUpdatedDaysAgo({required int days}) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'дня',
      many: 'дней',
      few: 'дня',
      one: 'день',
    );
    return 'Обновлено $days $_temp0 назад';
  }

  @override
  String get mileageHeaderStaleSuffix => 'обновить';

  @override
  String nearestDueOverdue({required String value}) {
    return 'Просрочено: $value';
  }

  @override
  String nearestDueSoon({required String value}) {
    return 'Ближайшее ТО через $value';
  }

  @override
  String dayShort({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String get navSchedule => 'График работ';

  @override
  String get navPlanning => 'Планирование';

  @override
  String get navHistory => 'Выполнено';

  @override
  String get exitConfirmMessage => 'Нажмите ещё раз для выхода';

  @override
  String markDoneMultiTitle({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count работы',
      many: '$count работ',
      few: '$count работы',
      one: '$count работу',
    );
    return 'Выполнить $_temp0';
  }

  @override
  String get markDoneMultiWorksSection => 'Работы';

  @override
  String get markDoneMultiNoteHint => 'Например, сервис на Ленина';

  @override
  String markDoneMultiSaveButton({required int count}) {
    return 'Выполнить $count';
  }

  @override
  String markDoneUpdateMileageMessage(
      {required String current, required String performed}) {
    return 'Текущий пробег: $current км.\nПробег выполнения: $performed км.\n\nОбновить текущий пробег машины до $performed км?';
  }

  @override
  String get actionNo => 'Нет';

  @override
  String get actionYes => 'Да';

  @override
  String get markDoneTitleEdit => 'Изменить событие';

  @override
  String get markDoneTitleRule => 'Выполнить работу';

  @override
  String get markDoneTitleAdd => 'Добавить событие';

  @override
  String get markDoneWorkLabel => 'Работа';

  @override
  String get markDoneWorkHint => 'Например, поменял лампочку';

  @override
  String get markDoneMileageLabel => 'Пробег выполнения';

  @override
  String get markDoneMonthLabel => 'Месяц выполнения';

  @override
  String get markDoneCostLabel => 'Стоимость';

  @override
  String get markDoneCostHint => 'Необязательно';

  @override
  String get markDoneNoteHint => 'Например, синтетическое масло';

  @override
  String get mileageErrorTooSmall =>
      'Пробег подозрительно мал — проверьте значение';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать';

  @override
  String get onboardingWelcomeSubtitle =>
      'Пара вопросов, чтобы приложение\nсразу считало сроки ТО';

  @override
  String get onboardingCarNameLabel => 'Название машины';

  @override
  String get onboardingCarNameHint => 'Например, Моя ласточка';

  @override
  String get onboardingCarNameHelper => 'Необязательно';

  @override
  String get onboardingMileageLabel => 'Текущий пробег';

  @override
  String get onboardingThemeTitle => 'Тема';

  @override
  String get onboardingThemeHint => 'Можно изменить позже в настройках';

  @override
  String get onboardingContinue => 'Продолжить';

  @override
  String onboardingSaveError({required String error}) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeDialogTitle => 'Тема оформления';

  @override
  String get rulesAddTooltip => 'Добавить правило';

  @override
  String get rulesEmptyTitle => 'Планов пока нет';

  @override
  String get rulesEmptyMessage =>
      'Добавьте плановое ТО с интервалом\nи оно появится в графике работ';

  @override
  String get rulesHowToStart => 'С чего начать?';

  @override
  String rulesDeleteTitle({required String title}) {
    return 'Удалить правило «$title»?';
  }

  @override
  String get rulesDeleteMessage => 'История выполненных работ не изменится.';

  @override
  String kmWithValue({required String km}) {
    return '$km км';
  }

  @override
  String monthsWithValue({required int months}) {
    return '$months мес';
  }

  @override
  String ruleCardEveryOne({required String value}) {
    return 'Каждые $value';
  }

  @override
  String ruleCardEveryTwo({required String first, required String second}) {
    return 'Каждые $first или $second';
  }

  @override
  String ruleCardNextOne({required String value}) {
    return 'Следующее: $value';
  }

  @override
  String ruleCardNextTwo({required String first, required String second}) {
    return 'Следующее: $first · $second';
  }

  @override
  String get ruleCardNextNotSet => 'Следующее ТО не задано';

  @override
  String ruleCardCost({required String amount}) {
    return '~$amount ₽';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionCar => 'Автомобиль';

  @override
  String get settingsSectionReminders => 'Напоминания о пробеге';

  @override
  String get settingsSectionThresholds => 'Пороги предупреждения';

  @override
  String get settingsSectionAppearance => 'Внешний вид';

  @override
  String get settingsSectionData => 'Данные';

  @override
  String get settingsSectionSupport => 'Помощь и поддержка';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsCarNameTitle => 'Название';

  @override
  String get settingsCarNameNotSet => 'Не задано';

  @override
  String get settingsCarNameDialogTitle => 'Название машины';

  @override
  String get settingsCarNameHint => 'Например, Моя ласточка';

  @override
  String get settingsRemindEnabled => 'Напоминать об обновлении пробега';

  @override
  String get settingsRemindDaysTitle => 'Как часто';

  @override
  String get settingsRemindDaysDialogTitle => 'Напоминать каждые';

  @override
  String get settingsRemindDaysUnit => 'дней';

  @override
  String settingsRemindDaysValue({required int days}) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'дня',
      many: 'дней',
      few: 'дня',
      one: 'день',
    );
    return '$days $_temp0';
  }

  @override
  String get settingsYellowKmTitle => 'За сколько км';

  @override
  String get settingsYellowKmDialogTitle => 'Порог предупреждения по км';

  @override
  String get settingsYellowMonthsTitle => 'За сколько месяцев';

  @override
  String get settingsYellowMonthsDialogTitle => 'Порог предупреждения по сроку';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String get settingsExportTitle => 'Экспорт данных';

  @override
  String get settingsExportSubtitle => 'Сохранить всё в JSON-файл';

  @override
  String get settingsExportSubject => 'Журнал ТО — резервная копия';

  @override
  String get settingsExportFailed => 'Не удалось сохранить файл';

  @override
  String settingsExportSaved({required String path}) {
    return 'Файл сохранён: $path';
  }

  @override
  String get settingsImportTitle => 'Импорт данных';

  @override
  String get settingsImportSubtitle => 'Загрузить из JSON-файла';

  @override
  String get settingsImportConfirmTitle => 'Импортировать данные?';

  @override
  String get settingsImportConfirmMessage =>
      'Все текущие данные будут заменены содержимым файла.';

  @override
  String get settingsImportConfirmAction => 'Импортировать';

  @override
  String get settingsImportWrongExtension =>
      'Выберите файл с расширением .json';

  @override
  String get settingsImportFailed => 'Не удалось импортировать файл';

  @override
  String get settingsImportSuccess => 'Данные импортированы';

  @override
  String get settingsRestoreTitle => 'Восстановить из архива';

  @override
  String get settingsRestoreSubtitle => 'Автоматические резервные копии';

  @override
  String get settingsRestoreConfirmTitle => 'Восстановить из архива?';

  @override
  String get settingsRestoreConfirmMessage =>
      'Все текущие данные будут заменены содержимым архива.';

  @override
  String get settingsRestoreConfirmAction => 'Восстановить';

  @override
  String get settingsRestoreFailed => 'Не удалось восстановить архив';

  @override
  String get settingsRestoreSuccess => 'Данные восстановлены из архива';

  @override
  String get settingsRestoreEmpty => 'Архивных копий пока нет';

  @override
  String settingsBackupSizeBytes({required int size}) {
    return '$size Б';
  }

  @override
  String settingsBackupSizeKb({required String size}) {
    return '$size КБ';
  }

  @override
  String get settingsHelpSubtitle => 'Как пользоваться приложением';

  @override
  String get settingsShareTitle => 'Поделиться приложением';

  @override
  String get settingsShareSubtitle => 'Отправить ссылку на магазин';

  @override
  String settingsShareText({required String appTitle, required String url}) {
    return 'Попробуй приложение «$appTitle» — дневник обслуживания автомобиля.\n\n$url';
  }

  @override
  String get settingsCoffeeTitle => 'Угостить автора бокалом кофе';

  @override
  String get settingsCoffeeSubtitle => 'Поддержать разработку';

  @override
  String get settingsVersionTitle => 'Версия';

  @override
  String get splashLoadError => 'Не удалось загрузить данные';

  @override
  String get splashRetry => 'Повторить';

  @override
  String get notificationChannelName => 'Напоминание о пробеге';

  @override
  String get notificationChannelDescription =>
      'Приложение просит обновить пробег машины';

  @override
  String get notificationMileageTitle => 'Пора обновить пробег';

  @override
  String notificationMileageTitleWithCar({required String carName}) {
    return '$carName: пора обновить пробег';
  }

  @override
  String get notificationMileageBodyStale => 'Данные о пробеге устарели';

  @override
  String get notificationMileageBodyOneDay => 'Данные устарели 1 день назад';

  @override
  String notificationMileageBodyDays({required int days}) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'дня',
      many: 'дней',
      few: 'дня',
      one: 'день',
    );
    return 'Данные устарели $days $_temp0 назад';
  }

  @override
  String get notificationActionUpdate => 'Обновить';

  @override
  String get notificationActionLater => 'Позже';
}
