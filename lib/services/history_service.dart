// lib/services/history_service.dart

import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/screens/mark_done/mark_done_screen.dart';

class HistoryService {
  const HistoryService();

  Future<void> applyMarkDoneFromHome({
    required MarkDoneResult result,
    required HistoryProvider history,
    required MileageProvider mileage,
  }) async {
    await history.add(result.record);

    if (result.updatedMileage != null) {
      await mileage.add(result.updatedMileage!);
    }
  }

  Future<void> applyManualHistoryAdd({
    required MarkDoneResult result,
    required HistoryProvider history,
  }) async {
    await history.add(result.record);
  }

  Future<void> applyHistoryUpdate({
    required MarkDoneResult result,
    required HistoryProvider history,
  }) async {
    await history.update(result.record);
  }
}
