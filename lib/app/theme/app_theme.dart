import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_motion.dart';

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFF3EEE6);
  static const Color surface = Color(0xFFFFFBF5);
  static const Color surfaceMuted = Color(0xFFEAE3D8);
  static const Color primary = Color(0xFF2F5D56);
  static const Color primarySoft = Color(0xFF3F7A70);
  static const Color onPrimary = Color(0xFFF8F4EE);
  static const Color text = Color(0xFF1C2A27);
  static const Color muted = Color(0xFF6A7572);
  static const Color border = Color(0xFFDDD4C6);
  static const Color accent = Color(0xFFC46A3A);
  static const Color error = Color(0xFFB54A3C);
  static const Color success = Color(0xFF3D7A5A);

  /// Painel da Academia: menu, snackbar e placeholder de capa.
  static const Color panel = Color(0xFF16302C);

  /// Creme sobre foto e texto do menu.
  static const Color ink = Color(0xFFF6F1E8);

  /// Metal da marca: cadeado premium, seções do menu, selo sobre capa.
  static const Color gold = Color(0xFFD7B49A);

  /// Texto secundário sobre o painel escuro.
  static const Color panelMuted = Color(0xFFC9D0CC);

  /// Sucesso sobre foto ou hero escuro.
  static const Color successOnDark = Color(0xFF7CBA6F);
  static const Color nightBackground = Color(0xFF050505);
  static const Color nightSurface = Color(0xFF141816);
  static const Color nightText = Color(0xFFF3EEE6);
  static const Color nightMuted = Color(0xFF9AA39F);
}

class AppFonts {
  const AppFonts._();

  static const String family = 'Outfit';
}

class AppSpacing {
  const AppSpacing._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double radius = 20;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.muted,
      error: AppColors.error,
      onError: AppColors.onPrimary,
      outline: AppColors.border,
    );
    return _build(scheme, AppColors.background, AppColors.text);
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primarySoft,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.nightSurface,
      onSurface: AppColors.nightText,
      onSurfaceVariant: AppColors.nightMuted,
      surfaceContainer: AppColors.nightSurface,
      surfaceContainerLow: AppColors.nightBackground,
      surfaceContainerHighest: Color(0xFF1E2321),
      error: AppColors.error,
      onError: AppColors.onPrimary,
      outline: Color(0xFF2A302E),
    );
    return _build(scheme, AppColors.nightBackground, AppColors.nightText);
  }

  static ThemeData _build(ColorScheme scheme, Color background, Color text) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.family,
      scaffoldBackgroundColor: background,
      canvasColor: background,
    );

    final textTheme = base.textTheme
        .copyWith(
          headlineMedium: TextStyle(
            fontFamily: AppFonts.family,
            color: text,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.2,
            letterSpacing: -0.4,
          ),
          titleLarge: TextStyle(
            fontFamily: AppFonts.family,
            color: text,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            height: 1.25,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(
            fontFamily: AppFonts.family,
            color: text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppFonts.family,
            color: text,
            fontSize: 16,
            height: 1.45,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppFonts.family,
            color: text,
            fontSize: 14,
            height: 1.4,
          ),
          labelSmall: TextStyle(
            fontFamily: AppFonts.family,
            color: scheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        )
        .apply(
          bodyColor: text,
          displayColor: text,
          fontFamily: AppFonts.family,
        );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.secondary,
        inactiveTrackColor: scheme.outline.withValues(alpha: 0.35),
        thumbColor: scheme.secondary,
        overlayColor: scheme.secondary.withValues(alpha: 0.12),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.brightness == Brightness.dark
            ? AppColors.ink
            : AppColors.panel,
        contentTextStyle: TextStyle(
          color: scheme.brightness == Brightness.dark
              ? AppColors.text
              : AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          height: 1.3,
        ),
        actionTextColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        elevation: 0,
        height: 72,
        indicatorColor: scheme.primary.withValues(
          alpha: scheme.brightness == Brightness.dark ? 0.28 : 0.18,
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SoftPageTransitionsBuilder(),
          TargetPlatform.iOS: SoftPageTransitionsBuilder(),
          TargetPlatform.windows: SoftPageTransitionsBuilder(),
          TargetPlatform.linux: SoftPageTransitionsBuilder(),
          TargetPlatform.macOS: SoftPageTransitionsBuilder(),
        },
      ),
    );
  }
}
