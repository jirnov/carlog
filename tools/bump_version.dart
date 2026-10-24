import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

Future<void> main() async {
  // 1. Ищем pubspec.yaml в текущей папке и выше
  final pubspecFile = _findPubspec();
  if (pubspecFile == null) {
    stderr.writeln('Ошибка: pubspec.yaml не найден ни в текущей папке, ни выше.');
    exit(1);
  }
  print('Используется: ${pubspecFile.path}');

  // 2. Читаем и парсим версию
  final content = pubspecFile.readAsStringSync();
  final yamlMap = loadYaml(content);
  final currentVersion = yamlMap['version'] as String?;

  if (currentVersion == null) {
    stderr.writeln('Ошибка: ключ version не найден в pubspec.yaml.');
    exit(1);
  }

  // 3. Разбираем версию (ожидаем формат 0.0.X)
  final parts = currentVersion.split('.');
  if (parts.length != 3) {
    stderr.writeln('Ошибка: ожидается формат версии 0.0.X, получено: $currentVersion');
    exit(1);
  }

  final major = int.tryParse(parts[0]);
  final minor = int.tryParse(parts[1]);
  final patch = int.tryParse(parts[2]);

  if (major == null || minor == null || patch == null) {
    stderr.writeln('Ошибка: нечисловые компоненты версии.');
    exit(1);
  }

  final newVersion = '$major.$minor.${patch + 1}';
  print('Версия: $currentVersion -> $newVersion');

  // 4. Обновляем pubspec.yaml (сохраняя форматирование)
  final editor = YamlEditor(content);
  editor.update(['version'], newVersion);
  pubspecFile.writeAsStringSync(editor.toString());

  // 5. Git add и commit
  await _runGit(['add', pubspecFile.path], pubspecFile.parent.path);
  await _runGit(
    ['commit', '-m', 'chore: bump version to $newVersion'],
    pubspecFile.parent.path,
  );

  // 6. Создаём тег
  final tagName = 'v$newVersion';
  await _runGit(['tag', tagName], pubspecFile.parent.path);

  print('Готово. Создан тег: $tagName');

  // 7. Пушим коммит и тег в origin
  print('Пуш в origin...');
  await _runGit(['push', 'origin', 'HEAD'], pubspecFile.parent.path);
  await _runGit(['push', 'origin', tagName], pubspecFile.parent.path);
}

/// Ищет pubspec.yaml в текущей директории и выше по дереву.
File? _findPubspec() {
  var dir = Directory.current;

  while (true) {
    final candidate = File('${dir.path}${Platform.pathSeparator}pubspec.yaml');
    if (candidate.existsSync()) {
      return candidate;
    }

    final parent = dir.parent;
    // Достигли корня файловой системы
    if (parent.path == dir.path) {
      return null;
    }
    dir = parent;
  }
}

Future<void> _runGit(List<String> args, String workingDirectory) async {
  final result = await Process.run(
    'git',
    args,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode != 0) {
    stderr.writeln('Git ошибка (${args.join(' ')}): ${result.stderr}');
    exit(result.exitCode);
  }
}