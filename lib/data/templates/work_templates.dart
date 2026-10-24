// lib/data/templates/work_templates.dart

import 'package:carlog/l10n/app_localizations.dart';

/// Один типовой шаблон работы.
///
/// `title`    — название работы (показывается жирным).
/// `subtitle` — необязательная уточняющая строка (показывается под названием).
/// `intervalKm`     — интервал по км, null если не задан.
/// `intervalMonths` — интервал по месяцам, null если не задан.
class WorkTemplate {
  const WorkTemplate({
    required this.title,
    this.subtitle,
    this.intervalKm,
    this.intervalMonths,
  });

  final String title;
  final String? subtitle;
  final int? intervalKm;
  final int? intervalMonths;
}

/// Категория типовых работ.
class WorkCategory {
  const WorkCategory({
    required this.name,
    required this.items,
  });

  final String name;
  final List<WorkTemplate> items;
}

/// Список типовых работ, сгруппированный по категориям.
List<WorkCategory> buildWorkTemplates(AppLocalizations l10n) {
  return [
    WorkCategory(
      name: l10n.workCategoryEngine,
      items: [
        WorkTemplate(
          title: l10n.workEngineOilChange,
          intervalKm: 10000,
          intervalMonths: 12,
        ),
        WorkTemplate(
          title: l10n.workAirFilterReplace,
          intervalKm: 30000,
          intervalMonths: 24,
        ),
        WorkTemplate(
          title: l10n.workFuelFilterReplace,
          intervalKm: 30000,
          intervalMonths: 24,
        ),
        WorkTemplate(
          title: l10n.workSparkPlugReplace,
          intervalKm: 60000,
          intervalMonths: 48,
        ),
        WorkTemplate(
          title: l10n.workTimingBeltReplace,
          intervalKm: 90000,
          intervalMonths: 72,
        ),
        WorkTemplate(
          title: l10n.workAntifreezeReplace,
          intervalKm: 60000,
          intervalMonths: 60,
        ),
      ],
    ),
    WorkCategory(
      name: l10n.workCategoryTransmission,
      items: [
        WorkTemplate(
          title: l10n.workMtmOilChange,
          intervalKm: 60000,
          intervalMonths: 60,
        ),
        WorkTemplate(
          title: l10n.workAtmOilChange,
          intervalKm: 60000,
          intervalMonths: 48,
        ),
        WorkTemplate(
          title: l10n.workCvtOilChange,
          intervalKm: 60000,
          intervalMonths: 48,
        ),
      ],
    ),
    WorkCategory(
      name: l10n.workCategoryAwd,
      items: [
        WorkTemplate(
          title: l10n.workHaldexOilChange,
          intervalKm: 60000,
          intervalMonths: 48,
        ),
        WorkTemplate(
          title: l10n.workTransferCaseOilChange,
          subtitle: l10n.workTransferCaseOilChangeSubtitle,
          intervalKm: 60000,
          intervalMonths: 48,
        ),
        WorkTemplate(
          title: l10n.workDifferentialOilChange,
          intervalKm: 60000,
          intervalMonths: 60,
        ),
      ],
    ),
    WorkCategory(
      name: l10n.workCategoryBrakes,
      items: [
        WorkTemplate(
          title: l10n.workBrakeFluidReplace,
          intervalKm: 40000,
          intervalMonths: 24,
        ),
        WorkTemplate(
          title: l10n.workBrakePadReplace,
          intervalKm: 30000,
        ),
        WorkTemplate(
          title: l10n.workBrakeDiscReplace,
          intervalKm: 60000,
        ),
        WorkTemplate(
          title: l10n.workBrakeDrumReplace,
          intervalKm: 80000,
        ),
      ],
    ),
    WorkCategory(
      name: l10n.workCategoryInterior,
      items: [
        WorkTemplate(
          title: l10n.workCabinFilterReplace,
          intervalKm: 20000,
          intervalMonths: 12,
        ),
      ],
    ),
  ];
}
