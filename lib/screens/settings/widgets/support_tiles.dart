// lib/screens/settings/widgets/support_tiles.dart

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/screens/help/help_screen.dart';
import 'package:carlog/screens/settings/app_store.dart';

class HelpTile extends StatelessWidget {
  const HelpTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: Text(l10n.helpTitle),
      subtitle: Text(l10n.settingsHelpSubtitle),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HelpScreen()),
        );
      },
    );
  }
}

class ShareTile extends StatelessWidget {
  const ShareTile({super.key, required this.storeUrl});

  final String storeUrl;

  Future<void> _share(BuildContext context) async {
    final l10n = context.l10n;
    final params = ShareParams(
      text: l10n.settingsShareText(
        appTitle: l10n.appTitle,
        url: storeUrl,
      ),
      subject: l10n.appTitle,
    );
    await SharePlus.instance.share(params);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.share_outlined),
      title: Text(l10n.settingsShareTitle),
      subtitle: Text(l10n.settingsShareSubtitle),
      onTap: () => _share(context),
    );
  }
}

class CoffeeTile extends StatelessWidget {
  const CoffeeTile({super.key});

  Future<void> _openCoffee() async {
    final uri = Uri.parse(kCoffeeUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Не удалось открыть — ничего страшного.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final beerColor = isDark ? Colors.amber.shade400 : Colors.brown.shade600;

    return ListTile(
      leading: Transform.flip(
        flipX: true,
        child: Icon(Icons.sports_bar, color: beerColor),
      ),
      title: Text(l10n.settingsCoffeeTitle),
      subtitle: Text(l10n.settingsCoffeeSubtitle),
      onTap: _openCoffee,
    );
  }
}