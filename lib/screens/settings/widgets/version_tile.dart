// lib/screens/settings/widgets/version_tile.dart

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:carlog/l10n/context_l10n.dart';

class VersionTile extends StatefulWidget {
  const VersionTile({super.key});

  @override
  State<VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<VersionTile> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(l10n.settingsVersionTitle),
      subtitle: Text(_version ?? '…'),
    );
  }
}