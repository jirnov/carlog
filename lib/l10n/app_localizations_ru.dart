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
}
