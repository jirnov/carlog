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
    if (value == null) return l10n.validationRequired;
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
      // Сохраняем и применяем сразу.
      await provider.setThemeMode(result);
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

      // 1. Название машины.
      final carName = _carNameController.text.trim();
      if (carName.isNotEmpty) {
        await settingsProvider.setCarName(carName);
      }

      // 2. Первая запись в журнал пробега.
      await mileageProvider.add(_mileage!);

      // 3. Флаг онбординга — последним.
      // Тема уже сохранена при выборе в _pickTheme.
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

                      // Иконка
                      Center(
                        child: Icon(
                          Icons.directions_car_outlined,
                          size: 96,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Заголовок
                      Text(
                        l10n.onboardingWelcomeTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Подзаголовок
                      Text(
                        l10n.onboardingWelcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Название машины
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

                      // Пробег
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
                          suffixText: l10n.onboardingMileageUnit,
                          errorText: _mileageError,
                          helperText: _mileageError == null
                              ? l10n.onboardingMileageRequired
                              : null,
                        ),
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),

                      // Тема оформления — как в настройках.
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

                      // Кнопка
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
