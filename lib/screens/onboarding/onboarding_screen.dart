// lib/screens/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/theme_mode_preference.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/utils/formatting.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _carNameController = TextEditingController();
  final _mileageController = TextEditingController();
  final _mileageFocus = FocusNode();

  String? _mileageError;
  bool _isSaving = false;

  /// Последняя известная локаль — чтобы отследить смену языка
  /// и переформатировать введённые числа.
  String? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (_lastLocale != null && _lastLocale != locale) {
      _reformatMileage(locale);
    }
    _lastLocale = locale;
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _mileageController.dispose();
    _mileageFocus.dispose();
    super.dispose();
  }

  int? get _mileage => parseThousands(_mileageController.text);

  String? _validateMileage() {
    final l10n = context.l10n;
    final value = _mileage;
    if (value == null) return l10n.requiredField;
    if (value <= 0) return l10n.mileageErrorPositive;
    if (value > 10000000) return l10n.mileageErrorTooLarge;
    return null;
  }

  void _onMileageChanged(String _) {
    setState(() {
      _mileageError =
          _mileageController.text.isEmpty ? null : _validateMileage();
    });
  }

  bool get _canContinue {
    final value = _mileage;
    return value != null && value > 0 && value <= 10000000 && !_isSaving;
  }

  /// Переформатировать уже введённый пробег под новую локаль,
  /// сохранив позицию курсора (по количеству цифр слева от него).
  void _reformatMileage(String locale) {
    final oldText = _mileageController.text;
    if (oldText.isEmpty) return;

    final value = parseThousands(oldText);
    if (value == null) return;

    final formatted = formatThousands(value, locale);

    // Сколько цифр слева от курсора в старом тексте.
    final oldCursor = _mileageController.selection.baseOffset;
    int digitsBefore = 0;
    if (oldCursor > 0) {
      for (int i = 0; i < oldCursor && i < oldText.length; i++) {
        if (RegExp(r'\d').hasMatch(oldText[i])) digitsBefore++;
      }
    }

    // Найти соответствующую позицию в новом тексте.
    int newCursor = formatted.length;
    if (digitsBefore < value.toString().length) {
      int digitsSeen = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (digitsSeen == digitsBefore) {
          newCursor = i;
          break;
        }
        if (RegExp(r'\d').hasMatch(formatted[i])) digitsSeen++;
      }
    }

    _mileageController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor),
    );

    setState(() {
      _mileageError = _validateMileage();
    });
  }

  String _themeLabel(BuildContext context, ThemeModePreference pref) {
    final l10n = context.l10n;
    switch (pref) {
      case ThemeModePreference.system:
        return l10n.themeSystem;
      case ThemeModePreference.light:
        return l10n.themeLight;
      case ThemeModePreference.dark:
        return l10n.themeDark;
    }
  }

  String _localeLabel(BuildContext context, String? locale) {
    final l10n = context.l10n;
    switch (locale) {
      case 'ru':
        return l10n.languageRussian;
      case 'en':
        return l10n.languageEnglish;
      default:
        return l10n.languageSystem;
    }
  }

  Future<void> _pickTheme(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final current = provider.themeModePreference;
    final l10n = context.l10n;

    final result = await showDialog<ThemeModePreference>(
      context: context,
      builder: (dialogContext) {
        var selected = current;
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: Text(l10n.themeDialogTitle),
            children: [
              RadioGroup<ThemeModePreference>(
                groupValue: selected,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selected = value);
                  Navigator.of(dialogContext).pop(value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final pref in ThemeModePreference.values)
                      RadioListTile<ThemeModePreference>(
                        value: pref,
                        title: Text(_themeLabel(context, pref)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      await provider.setThemeMode(result);
    }
  }

  Future<void> _pickLocale(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final current = provider.locale;
    final l10n = context.l10n;

    final result = await showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(l10n.languageDialogTitle),
          children: [
            RadioListTile<String?>(
              value: null,
              groupValue: current,
              title: Text(l10n.languageSystem),
              onChanged: (value) => Navigator.of(dialogContext).pop(value),
            ),
            RadioListTile<String?>(
              value: 'ru',
              groupValue: current,
              title: Text(l10n.languageRussian),
              onChanged: (value) => Navigator.of(dialogContext).pop(value),
            ),
            RadioListTile<String?>(
              value: 'en',
              groupValue: current,
              title: Text(l10n.languageEnglish),
              onChanged: (value) => Navigator.of(dialogContext).pop(value),
            ),
          ],
        );
      },
    );

    if (context.mounted && result != null) {
      await provider.setLocale(result);
    }
  }

  Future<void> _onContinue() async {
    final error = _validateMileage();
    if (error != null) {
      setState(() => _mileageError = error);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final settingsProvider = context.read<SettingsProvider>();
      final mileageProvider = context.read<MileageProvider>();

      final carName = _carNameController.text.trim();
      if (carName.isNotEmpty) {
        await settingsProvider.setCarName(carName);
      }

      await mileageProvider.add(_mileage!);

      await settingsProvider.setOnboardingDone(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.onboardingSaveError(error: e.toString()),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final currentTheme = context.select<SettingsProvider, ThemeModePreference>(
      (p) => p.themeModePreference,
    );
    final currentLocale = context.select<SettingsProvider, String?>(
      (p) => p.locale,
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 2),
                      Center(
                        child: Icon(
                          Icons.directions_car_outlined,
                          size: 96,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.onboardingWelcomeTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.onboardingWelcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _carNameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: l10n.onboardingCarNameLabel,
                          hintText: l10n.onboardingCarNameHint,
                          helperText: l10n.onboardingCarNameHelper,
                        ),
                        onSubmitted: (_) => _mileageFocus.requestFocus(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _mileageController,
                        focusNode: _mileageFocus,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          ThousandsSeparatorFormatter(locale: locale),
                        ],
                        onChanged: _onMileageChanged,
                        decoration: InputDecoration(
                          labelText: l10n.onboardingMileageLabel,
                          suffixText: l10n.unitKm,
                          errorText: _mileageError,
                          helperText:
                              _mileageError == null ? l10n.requiredField : null,
                        ),
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.language),
                        title: Text(l10n.languageTitle),
                        subtitle: Text(_localeLabel(context, currentLocale)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _pickLocale(context),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.brightness_6_outlined),
                        title: Text(l10n.onboardingThemeTitle),
                        subtitle: Text(_themeLabel(context, currentTheme)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _pickTheme(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 4),
                        child: Text(
                          l10n.onboardingThemeHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      FilledButton(
                        onPressed: _canContinue ? _onContinue : null,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.onboardingContinue),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
