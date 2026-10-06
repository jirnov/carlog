// lib/services/maintenance_service.dart

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/postponement.dart';
import 'package:carlog/data/models/rule.dart';
import 'package:carlog/data/models/settings.dart';
import 'package:carlog/utils/formatting.dart';

enum DueStatus { ok, soon, overdue }

class DueInfo {
  final Rule rule;
  final int? nextKm;
  final DateTime? nextDate;
  final int? kmLeft;
  final int? daysLeft;
  final DueStatus status;

  /// Сколько км пропущено (0 если не пропущено).
  final int missedKm;

  /// Отложка для этого правила, если есть активная.
  /// null — правило не отложено или отложка истекла.
  final Postponement? postponement;

  const DueInfo({
    required this.rule,
    this.nextKm,
    this.nextDate,
    this.kmLeft,
    this.daysLeft,
    required this.status,
    this.missedKm = 0,
    this.postponement,
  });

  bool get hasKm => kmLeft != null;
  bool get hasDate => daysLeft != null;
  bool get isOverdue => status == DueStatus.overdue;
  bool get isSoon => status == DueStatus.soon;

  /// Отложено ли правило на текущий момент.
  /// Истёкшая отложка не считается активной.
  bool get isPostponed =>
      postponement != null && postponement!.isActiveAt(DateTime.now());
}

class MaintenanceService {
  MaintenanceService(this._db);

  final AppDatabase _db;

  Future<List<DueInfo>> dueList() async {
    final rules = await _db.rules.getAll();
    if (rules.isEmpty) return [];

    final current = await _db.mileage.getCurrent();
    final settings = await _db.settings.get();

    if (current == null) return [];

    final today = dateOnly(DateTime.now());

    final list = <DueInfo>[];
    for (final rule in rules) {
      final postponement = await _db.postponements.getForRule(rule.id!);
      list.add(_calcDue(
        rule: rule,
        postponement: postponement,
        currentMileage: current.mileage,
        settings: settings,
        today: today,
      ));
    }

    list.sort((a, b) => _compare(a, b));
    return list;
  }

  Future<List<DueInfo>> activeDueList() async {
    final list = await dueList();
    return list.where((d) => !d.isPostponed).toList();
  }

  DueInfo _calcDue({
    required Rule rule,
    required Postponement? postponement,
    required int currentMileage,
    required Settings settings,
    required DateTime today,
  }) {
    final nextKm = rule.nextKm;
    final nextDate = rule.nextDate;

    int? kmLeft;
    int? daysLeft;

    if (nextKm != null) {
      kmLeft = nextKm - currentMileage;
    }
    if (nextDate != null) {
      daysLeft = nextDate.difference(today).inDays;
    }

    final missedKm = (kmLeft != null && kmLeft < 0) ? -kmLeft : 0;

    final overdueByKm = kmLeft != null && kmLeft < 0;
    final overdueByDate = daysLeft != null && daysLeft < 0;
    final soonByKm = kmLeft != null && kmLeft <= settings.yellowKm;
    final soonByDate =
        daysLeft != null && daysLeft <= settings.yellowMonths * 30;

    DueStatus status;
    if (overdueByKm || overdueByDate) {
      status = DueStatus.overdue;
    } else if (soonByKm || soonByDate) {
      status = DueStatus.soon;
    } else {
      status = DueStatus.ok;
    }

    return DueInfo(
      rule: rule,
      nextKm: nextKm,
      nextDate: nextDate,
      kmLeft: kmLeft,
      daysLeft: daysLeft,
      status: status,
      missedKm: missedKm,
      postponement: postponement,
    );
  }

  int _compare(DueInfo a, DueInfo b) {
    // Отложенные — вниз, независимо от статуса.
    if (a.isPostponed != b.isPostponed) {
      return a.isPostponed ? 1 : -1;
    }

    final order = {DueStatus.overdue: 0, DueStatus.soon: 1, DueStatus.ok: 2};
    final o = order[a.status]!.compareTo(order[b.status]!);
    if (o != 0) return o;
    final aKm = a.kmLeft ?? 1 << 30;
    final bKm = b.kmLeft ?? 1 << 30;
    return aKm.compareTo(bKm);
  }
}
