// lib/screens/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final value = _mileage;
    if (value == null) return 'Обязательное поле';
    if (value <= 0) return 'Пробег должен быть больше нуля';
    if (value > 10000000) return 'Слишком большое значение';
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
    return value != null &&
        value > 0 &&
        value <= 10000000 &&
        !_isSaving;
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

      final carName = _carNameController.text.trim();
      if (carName.isNotEmpty) {
        await settingsProvider.setCarName(carName);
      }

      await settingsProvider.setOnboardingDone(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось сохранить: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        'Добро пожаловать',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Пара вопросов, чтобы приложение\n'
                        'сразу считало сроки ТО',
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
                        decoration: const InputDecoration(
                          labelText: 'Название машины',
                          hintText: 'Например, SEAT Altea Freetrack',
                          helperText: 'Необязательно',
                        ),
                        onSubmitted: (_) => _mileageFocus.requestFocus(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _mileageController,
                        focusNode: _mileageFocus,
                        keyboardType: TextInputType.number,
                        inputFormatters: const [
                          ThousandsSeparatorFormatter(),
                        ],
                        onChanged: _onMileageChanged,
                        decoration: InputDecoration(
                          labelText: 'Текущий пробег',
                          suffixText: 'км',
                          errorText: _mileageError,
                          helperText: _mileageError == null
                              ? 'Обязательное поле'
                              : null,
                        ),
                        style: theme.textTheme.headlineSmall,
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
                            : const Text('Продолжить'),
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