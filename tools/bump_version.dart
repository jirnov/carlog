// ignore_for_file: avoid_print
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

  // 3. Разбираем версию формата X.X.X+Y (часть +Y обязательна)
  final plusIndex = currentVersion.indexOf('+');
  if (plusIndex == -1) {
    stderr.writeln(
      'Ошибка: ожидается формат версии X.X.X+Y, получено: $currentVersion',
    );
    exit(1);
  }

  final versionName = currentVersion.substring(0, plusIndex); // X.X.X
  final buildNumberStr = currentVersion.substring(plusIndex + 1); // Y

  // Проверяем, что versionName — это ровно три числовые части
  final nameParts = versionName.split('.');
  if (nameParts.length != 3 ||
      nameParts.any((p) => int.tryParse(p) == null)) {
    stderr.writeln(
      'Ошибка: ожидается формат X.X.X+Y с числовыми X, X, X, получено: $currentVersion',
    );
    exit(1);
  }

  final buildNumber = int.tryParse(buildNumberStr);
  if (buildNumber == null) {
    stderr.writeln(
      'Ошибка: число после "+" должно быть целым, получено: $buildNumberStr',
    );
    exit(1);
  }

  // 4. Увеличиваем только versionCode (число после "+")
  final newBuildNumber = buildNumber + 1;
  final newVersion = '$versionName+$newBuildNumber';
  final tagName = 'v$newVersion';
  print('Версия: $currentVersion -> $newVersion');

  // 5. Обновляем pubspec.yaml (сохраняя форматирование)
  final editor = YamlEditor(content);
  editor.update(['version'], newVersion);
  pubspecFile.writeAsStringSync(editor.toString());

  // 6. Git add и commit с сообщением "Set version to vX.X.X+Y"
  await _runGit(['add', pubspecFile.path], pubspecFile.parent.path);
  await _runGit(
    ['commit', '-m', 'Set version to $tagName'],
    pubspecFile.parent.path,
  );

  // 7. Создаём тег на текущий коммит
  await _runGit(['tag', tagName], pubspecFile.parent.path);

  print('Готово. Создан тег: $tagName');

  // 8. Пушим коммит и тег в origin
  print('Пуш в origin...');
  await _runGit(['push', 'origin', 'HEAD'], pubspecFile.parent.path);
  await _runGit(['push', 'origin', tagName], pubspecFile.parent.path);

  print('Пуш завершён.');
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