// lib/screens/edit_rule/edit_rule_screen.dart

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/dialogs/confirm_exit_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/utils/formatting.dart';

Future<Rule?> showEditRuleScreen(
  BuildContext context, {
  Rule? rule,
}) {
  return Navigator.of(context).push<Rule>(
    MaterialPageRoute(
      builder: (_) => EditRuleScreen(rule: rule),
    ),
  );
}

class EditRuleScreen extends StatefulWidget {
  const EditRuleScreen({super.key, this.rule});

  /// Если `rule == null` — «Своё»: пустая форма, фокус на названии.
  /// Если `rule.id == null` (но `rule != null`) — создание из шаблона:
  ///   название и интервалы предзаполнены, фокус на пробеге.
  /// Если `rule.id != null` — редактирование: фокус нигде.
  final Rule? rule;

  @override
  State<EditRuleScreen> createState() => _EditRuleScreenState();
}

class _EditRuleScreenState extends State<EditRuleScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final TextEditingController _nextKmController;
  late final TextEditingController _intervalKmController;
  late final TextEditingController _intervalMonthsController;
  late final TextEditingController _costController;

  late final String _initialTitle;
  late final String _initialNote;
  late final String _initialNextKm;
  late final String _initialIntervalKm;
  late final String _initialIntervalMonths;
  late final String _initialCost;
  late final DateTime? _initialNextDate;

  /// Дата следующего ТО. `null` = «Не указано».
  DateTime? _nextDate;

  String? _titleError;
  String? _nextKmError;
  String? _intervalError;
  bool _isSaving = false;

  bool get _isEditing => widget.rule?.id != null;
  bool get _isCustom => widget.rule == null;
  bool get _isFromTemplate => widget.rule != null && widget.rule!.id == null;

  int? get _nextKm => _parseInt(_nextKmController);
  int? get _intervalKm => _parseInt(_intervalKmController);
  int? get _intervalMonths => _parseInt(_intervalMonthsController);
  double? get _cost => _parseInt(_costController)?.toDouble();

  int get _currentMileage => context.read<MileageProvider>().currentMileage;

  /// Мягкое предупреждение: next_km меньше текущего пробега.
  /// Не блокирует сохранение — пользователь может сохранить осознанно.
  bool get _showNextKmWarning {
    final nextKm = _nextKm;
    if (nextKm == null || nextKm <= 0) return false;
    return nextKm <= _currentMileage;
  }

  /// Показывать ли поле «Дата следующего ТО».
  /// Только если задан интервал по месяцам.
  bool get _showNextDateField {
    final months = _intervalMonths;
    return months != null && months > 0;
  }

  @override
  void initState() {
    super.initState();

    final rule = widget.rule;
    // В initState нельзя надёжно использовать Localizations.localeOf(context),
    // поэтому берём системную локаль напрямую.
    final locale = PlatformDispatcher.instance.locale.languageCode;

    _titleController = TextEditingController(text: rule?.title ?? '');
    _noteController = TextEditingController(text: rule?.note ?? '');
    _nextKmController = TextEditingController(
      text: rule?.nextKm != null ? formatThousands(rule!.nextKm!, locale) : '',
    );
    _intervalKmController = TextEditingController(
      text: rule?.intervalKm != null
          ? formatThousands(rule!.intervalKm!, locale)
          : '',
    );
    _intervalMonthsController = TextEditingController(
      text: rule?.intervalMonths?.toString() ?? '',
    );
    _costController = TextEditingController(
      text: rule?.cost != null
          ? formatThousands(rule!.cost!.round(), locale)
          : '',
    );

    _nextDate = rule?.nextDate;

    _initialTitle = _titleController.text;
    _initialNote = _noteController.text;
    _initialNextKm = _nextKmController.text;
    _initialIntervalKm = _intervalKmController.text;
    _initialIntervalMonths = _intervalMonthsController.text;
    _initialCost = _costController.text;
    _initialNextDate = _nextDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _nextKmController.dispose();
    _intervalKmController.dispose();
    _intervalMonthsController.dispose();
    _costController.dispose();
    super.dispose();
  }

  int? _parseInt(TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return null;
    return parseThousands(text);
  }

  bool get _hasChanges {
    if (_titleController.text != _initialTitle) return true;
    if (_noteController.text != _initialNote) return true;
    if (_nextKmController.text != _initialNextKm) return true;
    if (_intervalKmController.text != _initialIntervalKm) return true;
    if (_intervalMonthsController.text != _initialIntervalMonths) return true;
    if (_costController.text != _initialCost) return true;
    if (!_isSameDate(_nextDate, _initialNextDate)) return true;
    return false;
  }

  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<bool> _confirmExit() async {
    if (!_hasChanges) return true;
    return showConfirmExitDialog(context);
  }

  bool _validate() {
    final l10n = context.l10n;
    final title = _titleController.text.trim();
    final nextKm = _nextKm;
    final intervalKm = _intervalKm;
    final intervalMonths = _intervalMonths;

    _titleError = title.isEmpty ? l10n.validationRequired : null;

    if (nextKm == null || nextKm <= 0) {
      _nextKmError = l10n.validationRequired;
    } else {
      _nextKmError = null;
    }

    if ((intervalKm == null || intervalKm <= 0) &&
        (intervalMonths == null || intervalMonths <= 0)) {
      _intervalError = l10n.editRuleIntervalError;
    } else {
      _intervalError = null;
    }

    return _titleError == null &&
        _nextKmError == null &&
        _intervalError == null;
  }

  /// Пересчитать видимость предупреждения при вводе пробега.
  void _onNextKmChanged(String _) {
    setState(() {});
  }

  /// Пересчитать видимость поля даты при вводе интервала по месяцам.
  /// Если интервал стёрли — сбрасываем дату, чтобы не осталось «мёртвого»
  /// значения, которое не сдвигается в advance().
  void _onIntervalMonthsChanged(String _) {
    setState(() {
      if (!_showNextDateField) {
        _nextDate = null;
      }
    });
  }

  Future<void> _pickNextDate() async {
    final now = DateTime.now();
    final picked = await showMonthPicker(
      context: context,
      initialDate: _nextDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 30),
    );
    if (picked == null) return;
    setState(() => _nextDate = DateTime(picked.year, picked.month, 15));
  }

  void _clearNextDate() {
    setState(() => _nextDate = null);
  }

  void _onSave() {
    if (!_validate()) {
      setState(() {});
      return;
    }

    setState(() => _isSaving = true);

    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final nextKm = _nextKm;
    final intervalKm = _intervalKm;
    final intervalMonths = _intervalMonths;
    final cost = _cost;

    final resolvedNextKm = (nextKm != null && nextKm > 0) ? nextKm : null;
    final resolvedIntervalKm =
        (intervalKm != null && intervalKm > 0) ? intervalKm : null;
    final resolvedIntervalMonths =
        (intervalMonths != null && intervalMonths > 0) ? intervalMonths : null;

    // Страховка: если интервала по месяцам нет, дата не имеет смысла.
    final resolvedNextDate = resolvedIntervalMonths == null ? null : _nextDate;

    final result = Rule(
      id: widget.rule?.id,
      title: title,
      note: note,
      nextKm: resolvedNextKm,
      nextDate: resolvedNextDate,
      intervalKm: resolvedIntervalKm,
      intervalMonths: resolvedIntervalMonths,
      cost: cost,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final title = _isEditing ? l10n.editRuleTitleEdit : l10n.editRuleTitleNew;

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
          title: Text(title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Название
              TextField(
                controller: _titleController,
                autofocus: _isCustom,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.editRuleNameLabel,
                  hintText: l10n.editRuleNameHint,
                  errorText: _titleError,
                ),
              ),
              const SizedBox(height: 24),

              // Пробег следующего ТО
              TextField(
                controller: _nextKmController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ThousandsSeparatorFormatter(locale: locale),
                ],
                autofocus: _isFromTemplate,
                onChanged: _onNextKmChanged,
                decoration: InputDecoration(
                  labelText: l10n.editRuleNextKmLabel,
                  suffixText: l10n.editRuleNextKmUnit,
                  errorText: _nextKmError,
                ),
              ),
              if (_showNextKmWarning)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    l10n.editRuleNextKmWarning(
                      km: formatThousands(_currentMileage, locale),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Интервал
              Text(l10n.editRuleIntervalSection,
                  style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _intervalKmController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        ThousandsSeparatorFormatter(locale: locale),
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.editRuleIntervalKmLabel,
                        suffixText: l10n.editRuleIntervalKmUnit,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _intervalMonthsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: _onIntervalMonthsChanged,
                      decoration: InputDecoration(
                        labelText: l10n.editRuleIntervalMonthsLabel,
                        suffixText: l10n.editRuleIntervalMonthsUnit,
                      ),
                    ),
                  ),
                ],
              ),
              if (_intervalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _intervalError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Дата следующего ТО — только если задан интервал по месяцам.
              if (_showNextDateField) ...[
                _NextDateField(
                  nextDate: _nextDate,
                  locale: locale,
                  onTap: _pickNextDate,
                  onClear: _clearNextDate,
                ),
                const SizedBox(height: 24),
              ],

              // Примерная стоимость
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ThousandsSeparatorFormatter(locale: locale),
                ],
                decoration: InputDecoration(
                  labelText: l10n.editRuleCostLabel,
                  hintText: l10n.editRuleCostHint,
                  suffixText: l10n.editRuleCostUnit,
                ),
              ),
              const SizedBox(height: 24),

              // Заметка
              TextField(
                controller: _noteController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.editRuleNoteLabel,
                  hintText: l10n.editRuleNoteHint,
                ),
              ),
              const SizedBox(height: 24),

              // Кнопка
              FilledButton(
                onPressed: _isSaving ? null : _onSave,
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

/// Поле «Дата следующего ТО» с кнопкой сброса.
class _NextDateField extends StatelessWidget {
  const _NextDateField({
    required this.nextDate,
    required this.locale,
    required this.onTap,
    required this.onClear,
  });

  final DateTime? nextDate;
  final String locale;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final hasDate = nextDate != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.editRuleNextDateLabel,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                hasDate
                    ? formatMonthYear(nextDate!, locale)
                    : l10n.editRuleNextDateNone,
                style: hasDate
                    ? null
                    : TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ),
        if (hasDate) ...[
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: l10n.editRuleResetDate,
            onPressed: onClear,
          ),
        ],
      ],
    );
  }
}
