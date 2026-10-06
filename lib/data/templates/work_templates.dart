// lib/data/templates/work_templates.dart

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
const List<WorkCategory> workTemplates = [
  WorkCategory(
    name: 'Двигатель',
    items: [
      WorkTemplate(
        title: 'Замена масла в двигателе',
        intervalKm: 10000,
        intervalMonths: 12,
      ),
      WorkTemplate(
        title: 'Замена воздушного фильтра',
        intervalKm: 30000,
        intervalMonths: 24,
      ),
      WorkTemplate(
        title: 'Замена топливного фильтра',
        intervalKm: 30000,
        intervalMonths: 24,
      ),
      WorkTemplate(
        title: 'Замена свечей зажигания',
        intervalKm: 60000,
        intervalMonths: 48,
      ),
      WorkTemplate(
        title: 'Замена ГРМ',
        intervalKm: 90000,
        intervalMonths: 72,
      ),
      WorkTemplate(
        title: 'Замена антифриза',
        intervalKm: 60000,
        intervalMonths: 60,
      ),
    ],
  ),
  WorkCategory(
    name: 'Трансмиссия',
    items: [
      WorkTemplate(
        title: 'Замена масла в МКПП',
        intervalKm: 60000,
        intervalMonths: 60,
      ),
      WorkTemplate(
        title: 'Замена масла в АКПП',
        intervalKm: 60000,
        intervalMonths: 48,
      ),
      WorkTemplate(
        title: 'Замена масла в вариаторе (CVT)',
        intervalKm: 60000,
        intervalMonths: 48,
      ),
    ],
  ),
  WorkCategory(
    name: 'Полный привод',
    items: [
      WorkTemplate(
        title: 'Замена масла в Haldex',
        intervalKm: 60000,
        intervalMonths: 48,
      ),
      WorkTemplate(
        title: 'Замена масла в раздатке',
        subtitle: 'xDrive / 4Matic / quattro',
        intervalKm: 60000,
        intervalMonths: 48,
      ),
      WorkTemplate(
        title: 'Замена масла в редукторе',
        intervalKm: 60000,
        intervalMonths: 60,
      ),
    ],
  ),
  WorkCategory(
    name: 'Тормоза',
    items: [
      WorkTemplate(
        title: 'Замена тормозной жидкости',
        intervalKm: 40000,
        intervalMonths: 24,
      ),
      WorkTemplate(
        title: 'Замена тормозных колодок',
        intervalKm: 30000,
      ),
      WorkTemplate(
        title: 'Замена тормозных дисков',
        intervalKm: 60000,
      ),
      WorkTemplate(
        title: 'Замена тормозных барабанов',
        intervalKm: 80000,
      ),
    ],
  ),
  WorkCategory(
    name: 'Салон',
    items: [
      WorkTemplate(
        title: 'Замена салонного фильтра',
        intervalKm: 20000,
        intervalMonths: 12,
      ),
    ],
  ),
];
