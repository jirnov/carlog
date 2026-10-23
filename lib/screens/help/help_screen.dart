// lib/screens/help/help_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String? _html;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    try {
      final content = await rootBundle.loadString('assets/help/help_ru.html');
      if (!mounted) return;
      setState(() => _html = content);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  /// Обработка кликов по ссылкам в HTML.
  ///
  /// Для `mailto:` собираем URI заново — с русским subject
  /// и текущей версией приложения. Это надёжнее, чем хардкодить
  /// закодированную строку в HTML.
  Future<void> _onLinkTap(String? url) async {
    if (url == null || url.isEmpty) return;

    Uri uri;
    if (url.startsWith('mailto:')) {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      final subject = 'Предложения по Журналу ТО (версия $version)';

      uri = Uri(
        scheme: 'mailto',
        path: 'evgeny@blog2k.ru',
        query: 'subject=${Uri.encodeComponent(subject)}',
      );
    } else {
      final parsed = Uri.tryParse(url);
      if (parsed == null) return;
      uri = parsed;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Не удалось открыть ссылку: $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь'),
      ),
      body: _buildBody(context, theme),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Не удалось загрузить справку',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_html == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Html(
        data: _html!,
        onLinkTap: (url, attributes, element) => _onLinkTap(url),
        style: {
          'body': Style(
            margin: Margins.symmetric(horizontal: 16),
            color: theme.colorScheme.onSurface,
          ),
          'h1': Style(
            color: theme.colorScheme.onSurface,
            fontSize: FontSize(22),
            margin: Margins.only(top: 16, bottom: 12),
          ),
          'h2': Style(
            color: theme.colorScheme.primary,
            fontSize: FontSize(18),
            margin: Margins.only(top: 24, bottom: 8),
          ),
          'h3': Style(
            color: theme.colorScheme.onSurface,
            fontSize: FontSize(15),
            margin: Margins.only(top: 16, bottom: 6),
          ),
          'p': Style(
            fontSize: FontSize(14),
            margin: Margins.symmetric(vertical: 6),
          ),
          'ul': Style(
            margin: Margins.only(left: 8, top: 4, bottom: 4),
          ),
          'ol': Style(
            margin: Margins.only(left: 8, top: 4, bottom: 4),
          ),
          'li': Style(
            fontSize: FontSize(14),
            margin: Margins.symmetric(vertical: 2),
          ),
          'code': Style(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.onSurface,
            fontSize: FontSize(13),
          ),
          'a': Style(
            color: theme.colorScheme.primary,
            textDecoration: TextDecoration.underline,
          ),
          '.note': Style(
            backgroundColor:
                theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
            padding: HtmlPaddings.all(12),
            margin: Margins.symmetric(vertical: 8),
          ),
        },
      ),
    );
  }
}
