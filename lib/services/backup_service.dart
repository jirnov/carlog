// lib/services/backup_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/services/export_import_service.dart';

/// Сервис автоматических резервных копий БД.
///
/// Копии лежат в `Documents/carlog_backups/` и видны пользователю
/// через файловый менеджер. Хранятся последние [_maxBackups] штук.
///
/// Бэкап создаётся только если:
/// - в БД есть данные (хотя бы одно правило или запись истории);
/// - содержимое не совпадает с последним бэкапом (без учёта `exported_at`).
class BackupService {
  BackupService(this._db) : _service = ExportImportService(_db);

  final AppDatabase _db;
  final ExportImportService _service;

  static const _backupDirName = 'carlog_backups';
  static const _maxBackups = 30;

  Future<Directory> _dir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_backupDirName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Создать бэкап, если есть данные и они отличаются от последнего.
  /// Возвращает путь к файлу, `null` — если бэкап не нужен или ошибка.
  /// Ошибки не пробрасываются — бэкап не должен ломать запуск.
  Future<String?> createBackupIfNeeded() async {
    try {
      if (!await _hasData()) return null;

      final json = await _service.exportToJson();
      if (await _isSameAsLatest(json)) return null;

      final dir = await _dir();
      final name = 'carlog_${_ts(DateTime.now())}.json';
      final file = File('${dir.path}/$name');
      await file.writeAsString(json);
      await _rotate();
      return file.path;
    } catch (e) {
      debugPrint('Backup error: $e');
      return null;
    }
  }

  /// Список бэкапов, новые — первыми.
  Future<List<File>> listBackups() async {
    final dir = await _dir();
    final entities = await dir.list().toList();
    final files = entities
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  /// Есть ли в БД данные, которые стоит бэкапить.
  /// Пробег и настройки не считаются — они есть всегда.
  Future<bool> _hasData() async {
    final rules = await _db.rules.getAll();
    if (rules.isNotEmpty) return true;
    final history = await _db.db.query('history', limit: 1);
    return history.isNotEmpty;
  }

  /// Совпадает ли JSON с последним бэкапом (без учёта `exported_at`).
  Future<bool> _isSameAsLatest(String json) async {
    final files = await listBackups();
    if (files.isEmpty) return false;

    try {
      final latest = await files.first.readAsString();
      return _normalize(latest) == _normalize(json);
    } catch (_) {
      // Если не удалось прочитать — считаем, что не совпадает.
      return false;
    }
  }

  /// Нормализовать JSON для сравнения: убрать `exported_at`.
  String _normalize(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) {
        decoded.remove('exported_at');
        return jsonEncode(decoded);
      }
      return json;
    } catch (_) {
      return json;
    }
  }

  /// Оставить только [_maxBackups] последних файлов.
  Future<void> _rotate() async {
    final files = await listBackups();
    if (files.length <= _maxBackups) return;
    for (final f in files.skip(_maxBackups)) {
      try {
        await f.delete();
      } catch (_) {
        // Не критично.
      }
    }
  }

  /// `2026-10-21_14-30-15` — сортируется лексикографически по времени.
  String _ts(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}'
        '_${two(d.hour)}-${two(d.minute)}-${two(d.second)}';
  }
}
