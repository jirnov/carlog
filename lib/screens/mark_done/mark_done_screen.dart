// lib/screens/mark_done/mark_done_screen.dart

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/history_record.dart';
import 'package:carlog/data/models/rule.dart';
import 'package:carlog/dialogs/confirm_exit_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/utils/formatting.dart';

const int _suspiciousJumpKm = 50000;

class MarkDoneResult {
  const MarkDoneResult({
    required this.record,
    required this.updatedMileage,
  });

  final HistoryRecord record;

  /// Пробег, до которого нужно обновить текущий пробег машины.
  /// `null` — не обновлять.
  final int? updatedMileage;
}

Future<MarkDoneResult?> showMarkDoneScreen(
  BuildContext context, {
  Rule? rule,
  HistoryRecord? record,
  String? initialTitle,
}) {
  return Navigator.of(context).push<MarkDoneResult>(
    MaterialPageRoute(
      builder: (_) => MarkDoneScreen(
        rule: rule,
        record: record,
        initialTitle: initialTitle,
      ),
    ),
  );
}

class MarkDoneScreen extends StatefulWidget {
  const MarkDoneScreen({
    super.key,
    this.rule,
    this.record,
    this.initialTitle,
  });

  final Rule? rule;
  final HistoryRecord? record;

  /// Предзаполненное название работы (из шаблона).
  /// Применяется только в режиме «Добавить событие».
  final String? initialTitle;

  @override
  State<MarkDoneScreen> createState() => _MarkDoneScreenState();
}

class _MarkDoneScreenState extends State<MarkDoneScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final TextEditingController _mileageController;
  late final TextEditingController _costController;

  late final String _initialTitle;
  late final String _initialNote;
  late final int _initialMileage;
  late final DateTime _initialDate;

  DateTime _date = _day15(DateTime.now());

  String? _mileageError;
  String? _titleError;
  bool _isSaving = false;

  bool get _isEditing => widget.record != null;
  bool get _isRuleFixed => widget.rule != null;
  bool get _strictMode => _isRuleFixed && !_isEditing;

  String _screenTitle(BuildContext context) {
    final l10n = context.l10n;
    if (_isEditing) return l10n.markDoneTitleEdit;
    if (_isRuleFixed) return l10n.markDoneTitleRule;
    return l10n.markDoneTitleAdd;
  }

  /// Привести дату к 15-му числу её месяца.
  static DateTime _day15(DateTime date) {
    return DateTime(date.year, date.month, 15);
  }

  @override
  void initState() {
    super.initState();

    final record = widget.record;
    final rule = widget.rule;

    if (record != null) {
      _titleController = TextEditingController(text: record.title);
      _noteController = TextEditingController(text: record.note);
      _mileageController = TextEditingController(
        text: formatThousands(record.mileage),
      );
      _date = _day15(record.performedAt);
      _costController = TextEditingController(
        text: record.cost != null ? formatThousands(record.cost!.round()) : '',
      );
    } else if (rule != null) {
      _titleController = TextEditingController(text: rule.title);
      _noteController = TextEditingController(text: rule.note);

      final currentMileage = context.read<MileageProvider>().currentMileage;
      _mileageController = TextEditingController(
        text: formatThousands(currentMileage),
      );
      // Стоимость берём из правила, если она там задана.
      _costController = TextEditingController(
        text: (rule.cost != null && rule.cost! > 0)
            ? formatThousands(rule.cost!.round())
            : '',
      );
    } else {
      _titleController = TextEditingController(text: widget.initialTitle ?? '');
      _noteController = TextEditingController();

      final currentMileage = context.read<MileageProvider>().currentMileage;
      _mileageController = TextEditingController(
        text: formatThousands(currentMileage),
      );
      _costController = TextEditingController();
    }

    _initialTitle = _titleController.text;
    _initialNote = _noteController.text;
    _initialMileage = parseThousands(_mileageController.text) ?? 0;
    _initialDate = _date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _mileageController.dispose();
    _costController.dispose();
    super.dispose();
  }

  int? get _mileage => parseThousands(_mileageController.text);

  String? _validateMileage() {
    final l10n = context.l10n;
    final value = _mileage;
    if (value == null) return l10n.validationRequired;
    if (value <= 0) return l10n.mileageErrorPositive;
    if (value > 10000000) return l10n.mileageErrorTooLarge;

    if (!_strictMode) return null;

    if (value < 1000) {
      return l10n.mileageErrorTooSmall;
    }

    return null;
  }

  bool get _canSave {
    return _titleController.text.trim().isNotEmpty &&
        _validateMileage() == null &&
        !_isSaving;
  }

  bool get _hasChanges {
    if (_titleController.text.trim() != _initialTitle) return true;
    if (_noteController.text != _initialNote) return true;
    if (_mileage != _initialMileage) return true;
    if (!_isSameDay(_date, _initialDate)) return true;
    return false;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onMileageChanged(String _) {
    setState(() {
      _mileageError =
          _mileageController.text.isEmpty ? null : _validateMileage();
    });
  }

  void _onTitleChanged(String _) {
    setState(() {
      _titleError = _titleController.text.trim().isEmpty
          ? context.l10n.validationRequired
          : null;
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

  Future<bool> _confirmExit() async {
    if (!_hasChanges) return true;
    return showConfirmExitDialog(context);
  }

  Future<bool> _confirmLargeJump(int value) async {
    if (!_strictMode) return true;

    final today = dateOnly(DateTime.now());
    if (!_isSameDay(_date, today)) return true;

    final currentMileage = context.read<MileageProvider>().currentMileage;
    final diff = value - currentMileage;
    if (diff <= _suspiciousJumpKm) return true;

    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.markDoneJumpTitle),
        content: Text(
          l10n.markDoneJumpMessage(
            current: formatThousands(currentMileage),
            performed: formatThousands(value),
            diff: formatThousands(diff),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.markDoneJumpEdit),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.markDoneJumpConfirm),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<bool> _confirmUpdateMileage(
    int newMileage,
    int currentMileage,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.markDoneUpdateMileageTitle),
        content: Text(
          l10n.markDoneUpdateMileageMessage(
            current: formatThousands(currentMileage),
            performed: formatThousands(newMileage),
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

    final confirmed = await _confirmLargeJump(mileage);
    if (!confirmed) return;
    if (!context.mounted) return;

    setState(() => _isSaving = true);

    final costText = _costController.text.trim();
    final cost = costText.isEmpty ? null : parseThousands(costText)?.toDouble();

    final record = HistoryRecord(
      id: widget.record?.id,
      title: _titleController.text.trim(),
      note: _noteController.text.trim(),
      mileage: mileage,
      performedAt: _date,
      cost: cost,
    );

    // Спросить про обновление пробега машины, если введённый пробег
    // больше текущего. Запись в MileageProvider — на стороне HomeScreen.
    int? updatedMileage;
    if (_strictMode) {
      final currentMileage = context.read<MileageProvider>().currentMileage;
      if (mileage > currentMileage) {
        final confirmed = await _confirmUpdateMileage(mileage, currentMileage);
        if (confirmed) {
          updatedMileage = mileage;
        }
      }
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(MarkDoneResult(
      record: record,
      updatedMileage: updatedMileage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final confirmed = await _confirmExit();
        if (confirmed && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final confirmed = await _confirmExit();
              if (confirmed && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(_screenTitle(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Работа
              if (_isRuleFixed)
                InputDecorator(
                  decoration:
                      InputDecoration(labelText: l10n.markDoneWorkLabel),
                  child: Text(_titleController.text),
                )
              else
                TextField(
                  controller: _titleController,
                  autofocus: !_isEditing &&
                      (widget.initialTitle == null ||
                          widget.initialTitle!.isEmpty),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: _onTitleChanged,
                  decoration: InputDecoration(
                    labelText: l10n.markDoneWorkLabel,
                    hintText: l10n.markDoneWorkHint,
                    errorText: _titleError,
                  ),
                ),
              const SizedBox(height: 16),

              // Пробег
              TextField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                inputFormatters: const [ThousandsSeparatorFormatter()],
                onChanged: _onMileageChanged,
                decoration: InputDecoration(
                  labelText: l10n.markDoneMileageLabel,
                  suffixText: l10n.markDoneMileageUnit,
                  errorText: _mileageError,
                ),
              ),
              const SizedBox(height: 16),

              // Месяц
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.markDoneMonthLabel,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(formatMonthYear(_date)),
                ),
              ),
              const SizedBox(height: 16),

              // Стоимость
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                inputFormatters: const [ThousandsSeparatorFormatter()],
                decoration: InputDecoration(
                  labelText: l10n.markDoneCostLabel,
                  hintText: l10n.markDoneCostHint,
                  suffixText: l10n.markDoneCostUnit,
                ),
              ),
              const SizedBox(height: 16),

              // Заметка
              TextField(
                controller: _noteController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.markDoneNoteLabel,
                  hintText: l10n.markDoneNoteHint,
                ),
              ),
              const SizedBox(height: 24),

              // Кнопка
              FilledButton(
                onPressed: _canSave ? _onSave : null,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.actionSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
