// lib/screens/mark_done/mark_done_multi_screen.dart

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/utils/formatting.dart';

class MarkDoneMultiResult {
  const MarkDoneMultiResult({
    required this.mileage,
    required this.performedAt,
    required this.note,
    required this.updatedMileage,
  });

  final int mileage;
  final DateTime performedAt;
  final String note;
  final int? updatedMileage;
}

Future<MarkDoneMultiResult?> showMarkDoneMultiScreen(
  BuildContext context, {
  required List<Rule> rules,
}) {
  return Navigator.of(context).push<MarkDoneMultiResult>(
    MaterialPageRoute(
      builder: (_) => MarkDoneMultiScreen(rules: rules),
    ),
  );
}

class MarkDoneMultiScreen extends StatefulWidget {
  const MarkDoneMultiScreen({super.key, required this.rules});

  final List<Rule> rules;

  @override
  State<MarkDoneMultiScreen> createState() => _MarkDoneMultiScreenState();
}

class _MarkDoneMultiScreenState extends State<MarkDoneMultiScreen> {
  late final TextEditingController _mileageController;
  late final TextEditingController _noteController;

  DateTime _date = _day15(DateTime.now());

  String? _mileageError;

  static DateTime _day15(DateTime date) {
    return DateTime(date.year, date.month, 15);
  }

  @override
  void initState() {
    super.initState();

    final currentMileage = context.read<MileageProvider>().currentMileage;
    _mileageController = TextEditingController(
      text: formatThousands(currentMileage),
    );
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int? get _mileage => parseThousands(_mileageController.text);

  String? _validateMileage() {
    final l10n = context.l10n;
    final value = _mileage;
    if (value == null) return l10n.validationRequired;
    if (value <= 0) return l10n.mileageErrorPositive;
    if (value > 10000000) return l10n.mileageErrorTooLarge;
    return null;
  }

  bool get _canSave => _validateMileage() == null;

  void _onMileageChanged(String _) {
    setState(() {
      _mileageError =
          _mileageController.text.isEmpty ? null : _validateMileage();
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showMonthPicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() => _date = _day15(picked));
  }

  Future<bool> _confirmUpdateMileage(int mileage, int currentMileage) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.markDoneMultiUpdateMileageTitle),
        content: Text(
          l10n.markDoneMultiUpdateMileageMessage(
            current: formatThousands(currentMileage),
            performed: formatThousands(mileage),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.actionYes),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _onSave() async {
    if (!_canSave) return;

    final mileage = _mileage!;
    final currentMileage = context.read<MileageProvider>().currentMileage;

    int? updatedMileage;
    if (mileage > currentMileage) {
      final confirmed = await _confirmUpdateMileage(mileage, currentMileage);
      if (confirmed) {
        updatedMileage = mileage;
      }
    }

    if (!mounted) return;

    Navigator.of(context).pop(MarkDoneMultiResult(
      mileage: mileage,
      performedAt: _date,
      note: _noteController.text.trim(),
      updatedMileage: updatedMileage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.markDoneMultiTitle(count: widget.rules.length)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.markDoneMultiWorksSection,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final rule in widget.rules) ...[
                      Text(
                        '• ${rule.title}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (rule != widget.rules.last) const SizedBox(height: 4),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _mileageController,
              keyboardType: TextInputType.number,
              inputFormatters: const [ThousandsSeparatorFormatter()],
              onChanged: _onMileageChanged,
              decoration: InputDecoration(
                labelText: l10n.markDoneMultiMileageLabel,
                suffixText: l10n.markDoneMultiMileageUnit,
                errorText: _mileageError,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.markDoneMultiMonthLabel,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(formatMonthYear(_date)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.markDoneMultiNoteLabel,
                hintText: l10n.markDoneMultiNoteHint,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _canSave ? _onSave : null,
              child: Text(
                  l10n.markDoneMultiSaveButton(count: widget.rules.length)),
            ),
          ],
        ),
      ),
    );
  }
}
