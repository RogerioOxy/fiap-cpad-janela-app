import 'dart:async';

import 'package:flutter/material.dart';

import 'data/reservas_repository.dart';
import 'screens/login_screen.dart';
import 'state/janela_state.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text.dart';
import 'theme/app_colors.dart';

void main() => runApp(const JanelaApp());

class JanelaApp extends StatefulWidget {
  const JanelaApp({super.key, this.repository});

  final ReservasRepository? repository;

  @override
  State<JanelaApp> createState() => _JanelaAppState();
}

class _JanelaAppState extends State<JanelaApp> with WidgetsBindingObserver {
  late final JanelaState _state = JanelaState(repository: widget.repository);
  late final Timer _relogio;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _relogio = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _state.atualizar(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _state.atualizar();
  }

  @override
  void dispose() {
    _relogio.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Janela',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
            ).copyWith(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              secondary: AppColors.primary,
              onSecondary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
              onSurfaceVariant: AppColors.textSecondary,
              error: AppColors.statusOcupado,
              outline: AppColors.border,
            ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.background,
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          titleTextStyle: AppText.cardTitle,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.surfaceAlt,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceAlt,
          selectedColor: AppColors.primary,
          secondaryLabelStyle: AppText.statusLabel.copyWith(
            color: AppColors.onPrimary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
      home: LoginScreen(state: _state),
    );
  }
}
