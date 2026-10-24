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
  String get onboardingWelcome => 'Добро пожаловать';

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
  String get confirmCancelTitle => 'Отменить ТО?';

  @override
  String confirmCancelMessage({required String ruleTitle}) {
    return 'Работа «$ruleTitle» будет помечена как отменённая. Она попадёт в историю со значком отмены и не будет считаться выполненной. Следующее ТО сдвинется на текущий пробег.';
  }

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionConfirmCancel => 'Отменить';

  @override
  String get actionDelete => 'Удалить';

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
  String get updateMileageTitle => 'Обновить пробег';

  @override
  String get updateMileageFieldLabel => 'Новый пробег';

  @override
  String get updateMileageUnitKm => 'км';

  @override
  String updateMileagePrevious({required String km}) {
    return 'Прошлый: $km км';
  }

  @override
  String get updateMileageDateToday => 'Дата: сегодня';

  @override
  String get mileageErrorRequired => 'Обязательное поле';

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
  String get editRuleNextKmUnit => 'км';

  @override
  String editRuleNextKmWarning({required String km}) {
    return 'Меньше текущего пробега ($km км). Возможно, ТО уже выполнено.';
  }

  @override
  String get editRuleIntervalSection => 'Интервал';

  @override
  String get editRuleIntervalKmLabel => 'По км';

  @override
  String get editRuleIntervalKmUnit => 'км';

  @override
  String get editRuleIntervalMonthsLabel => 'По месяцам';

  @override
  String get editRuleIntervalMonthsUnit => 'мес';

  @override
  String get editRuleIntervalError => 'Заполните хотя бы один интервал';

  @override
  String get editRuleCostLabel => 'Примерная стоимость';

  @override
  String get editRuleCostHint =>
      'Для статистики и планирования расходов (необязательно)';

  @override
  String get editRuleCostUnit => '₽';

  @override
  String get editRuleNoteLabel => 'Заметка';

  @override
  String get editRuleNoteHint => 'Например, синтетическое масло';

  @override
  String get editRuleNextDateLabel => 'Дата следующего ТО';

  @override
  String get editRuleNextDateNone => 'Не указано';

  @override
  String get editRuleResetDate => 'Сбросить';

  @override
  String get validationRequired => 'Обязательное поле';

  @override
  String get helpTitle => 'Помощь';

  @override
  String get helpLoadError => 'Не удалось загрузить справку';

  @override
  String helpMailSubject({required String version}) {
    return 'Предложения по Журналу ТО (версия $version)';
  }

  @override
  String get historyTitle => 'Выполнено';

  @override
  String get historyAddTooltip => 'Добавить событие';

  @override
  String get historyEmptyTitle => 'История пуста';

  @override
  String get historyEmptyMessage =>
      'Здесь появятся выполненные работы\nНо вы можете добавлять их самостоятельно';

  @override
  String get historyHowItWorks => 'Как это работает?';

  @override
  String historyDeleteTitle({required String title}) {
    return 'Удалить работу «$title»?';
  }

  @override
  String get historyDeleteMessage => 'Запись будет удалена из истории.';

  @override
  String historyCardMileage({required String km}) {
    return '$km км';
  }

  @override
  String historyCardCost({required String amount}) {
    return '$amount ₽';
  }

  @override
  String get historyCardEditTooltip => 'Редактировать';

  @override
  String get historyCardDeleteTooltip => 'Удалить';

  @override
  String get homeCarNameFallback => 'Мой автомобиль';

  @override
  String get homeSelectionCancel => 'Отмена';

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
  String get homeHowItWorks => 'Как это работает?';

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
  String dueCardKmLeft({required String km}) {
    return '$km км';
  }

  @override
  String get dueCardActionPostpone => '[Отложить]';

  @override
  String get dueCardActionMarkDone => '[Выполнить]';

  @override
  String dueDaysShort({required int count}) {
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
  String dueMonthsShort({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мес',
      many: '$count мес',
      few: '$count мес',
      one: '$count мес',
    );
    return '$_temp0';
  }

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
  String get mileageHeaderUnitKm => 'км';

  @override
  String get mileageHeaderUpdateButton => 'Обновить пробег';

  @override
  String nearestDueOverdue({required String value}) {
    return 'Просрочено: $value';
  }

  @override
  String nearestDueSoon({required String value}) {
    return 'Ближайшее ТО через $value';
  }

  @override
  String nearestDueKm({required String km}) {
    return '$km км';
  }

  @override
  String nearestDueDays({required int count}) {
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
  String nearestDueMonths({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мес',
      many: '$count мес',
      few: '$count мес',
      one: '$count мес',
    );
    return '$_temp0';
  }
}
