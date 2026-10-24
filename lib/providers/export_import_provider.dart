// lib/providers/export_import_provider.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/services/export_import_service.dart';

class ExportImportProvider extends ChangeNotifier {
  ExportImportProvider(AppDatabase db) : _service = ExportImportService(db);

  final ExportImportService _service;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  /// Экспорт в файл. Возвращает путь или null при ошибке.
  Future<String?> export() async {
    _setBusy(true);
    try {
      final json = await _service.exportToJson();

      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final file = File('${dir.path}/carlog_$timestamp.json');
      await file.writeAsString(json);

      return file.path;
    } catch (e) {
      debugPrint('Export error: $e');
      return null;
    } finally {
      _setBusy(false);
    }
  }

  /// Импорт из файла. true — успех, false — ошибка.
  Future<bool> import(String path) async {
    _setBusy(true);
    try {
      final file = File(path);
      if (!await file.exists()) {
        throw Exception('File not found');
      }

      final content = await file.readAsString();
      await _service.importFromJson(content);
      return true;
    } catch (e) {
      debugPrint('Import error: $e');
      return false;
    } finally {
      _setBusy(false);
    }
  }

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
