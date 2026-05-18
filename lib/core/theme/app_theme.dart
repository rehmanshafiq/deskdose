import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for DeskDose dark UI.
abstract final class AppColors {
  static const Color primary = Color(0xFF1D9E75);
  static const Color background = Color(0xFF111118);
  static const Color surface = Color.fromRGBO(255, 255, 255, 0.05);
  static const Color hydrationAccent = Color(0xFF378ADD);
  static const Color premiumAccent = Color(0xFFEF9F27);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFE8E8ED);
  static const Color onSurface = Color(0xFFE8E8ED);
  static const Color onSurfaceVariant = Color(0xFFB8B8C4);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFF1A1200);
  static const Color error = Color(0xFFE54D4D);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color outline = Color.fromRGBO(255, 255, 255, 0.12);
  static const Color outlineVariant = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFFE8E8ED);
  static const Color onInverseSurface = Color(0xFF1A1A22);
  static const Color inversePrimary = Color(0xFF5EC4A3);
  static const Color surfaceTint = primary;
  static const Color surfaceContainerLowest = Color(0xFF0C0C12);
  static const Color surfaceContainerLow = Color(0xFF14141C);
  static const Color surfaceContainer = Color(0xFF1A1A22);
  static const Color surfaceContainerHigh = Color(0xFF22222C);
  static const Color surfaceContainerHighest = Color(0xFF2A2A36);
}

abstract final class AppTheme {
  static const String _fontFamily = 'Plus Jakarta Sans';

  static ThemeData get dark => _buildDarkTheme();

  static ThemeData _buildDarkTheme() {
    final colorScheme = _colorScheme;
    final textTheme = _textTheme;
    final primaryTextTheme = _primaryTextTheme(textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      applyElevationOverlayColor: true,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      platform: TargetPlatform.iOS,
      splashFactory: InkRipple.splashFactory,
      fontFamily: _fontFamily,
      fontFamilyFallback: const <String>[
        'Helvetica',
        'Arial',
        'sans-serif',
      ],
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      canvasColor: AppColors.background,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.surface,
      dividerColor: AppColors.outline,
      focusColor: AppColors.primary.withValues(alpha: 0.24),
      hoverColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.12),
      hintColor: AppColors.onSurface.withValues(alpha: 0.5),
      shadowColor: AppColors.shadow,
      splashColor: AppColors.primary.withValues(alpha: 0.16),
      unselectedWidgetColor: AppColors.onSurface.withValues(alpha: 0.5),
      disabledColor: AppColors.onSurface.withValues(alpha: 0.38),
      secondaryHeaderColor: AppColors.hydrationAccent,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary.withValues(alpha: 0.7),
      primaryColorDark: AppColors.primary.withValues(alpha: 0.9),
      iconTheme: _iconTheme,
      primaryIconTheme: _iconTheme,
      appBarTheme: _appBarTheme(textTheme),
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme(textTheme),
      dividerTheme: _dividerTheme,
      inputDecorationTheme: _inputDecorationTheme(textTheme),
      elevatedButtonTheme: _elevatedButtonTheme(textTheme),
      filledButtonTheme: _filledButtonTheme(textTheme),
      outlinedButtonTheme: _outlinedButtonTheme(textTheme),
      textButtonTheme: _textButtonTheme(textTheme),
      floatingActionButtonTheme: _fabTheme,
      bottomNavigationBarTheme: _bottomNavTheme(textTheme),
      navigationBarTheme: _navigationBarTheme(textTheme),
      snackBarTheme: _snackBarTheme(textTheme),
      chipTheme: _chipTheme(textTheme),
      listTileTheme: _listTileTheme(textTheme),
      progressIndicatorTheme: _progressTheme,
      switchTheme: _switchTheme,
      checkboxTheme: _checkboxTheme,
      radioTheme: _radioTheme,
      sliderTheme: _sliderTheme,
      tabBarTheme: _tabBarTheme(textTheme),
      tooltipTheme: _tooltipTheme(textTheme),
      bottomSheetTheme: _bottomSheetTheme(textTheme),
      drawerTheme: _drawerTheme,
      popupMenuTheme: _popupMenuTheme(textTheme),
      bannerTheme: _bannerTheme(textTheme),
      badgeTheme: _badgeTheme,
      dataTableTheme: _dataTableTheme(textTheme),
      expansionTileTheme: _expansionTileTheme(textTheme),
      scrollbarTheme: _scrollbarTheme,
      textSelectionTheme: _textSelectionTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ColorScheme get _colorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: Color(0xFF0D4D3A),
        onPrimaryContainer: Color(0xFFB8F0DC),
        secondary: AppColors.hydrationAccent,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: Color(0xFF1A3D6B),
        onSecondaryContainer: Color(0xFFB8D4F5),
        tertiary: AppColors.premiumAccent,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: Color(0xFF5C3D0A),
        onTertiaryContainer: Color(0xFFFFE4B8),
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: Color(0xFF5C1A1A),
        onErrorContainer: Color(0xFFFFB8B8),
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: Color(0xFFB8B8C4),
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.onInverseSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
      );

  static TextTheme get _textTheme {
    final base = ThemeData(brightness: Brightness.dark).textTheme;
    return GoogleFonts.plusJakartaSansTextTheme(base).apply(
      bodyColor: AppColors.onSurface,
      displayColor: AppColors.onSurface,
    );
  }

  static TextTheme _primaryTextTheme(TextTheme textTheme) => textTheme.apply(
        bodyColor: AppColors.onPrimary,
        displayColor: AppColors.onPrimary,
      );

  static const IconThemeData _iconTheme = IconThemeData(
    color: AppColors.onSurface,
    size: 24,
  );

  static AppBarTheme _appBarTheme(TextTheme textTheme) => AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        iconTheme: _iconTheme,
      );

  static const CardThemeData _cardTheme = CardThemeData(
    elevation: 0,
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      side: BorderSide(color: AppColors.outline),
    ),
  );

  static DialogThemeData _dialogTheme(TextTheme textTheme) => DialogThemeData(
        backgroundColor: AppColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.outline,
    thickness: 1,
    space: 1,
  );

  static InputDecorationTheme _inputDecorationTheme(TextTheme textTheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurface.withValues(alpha: 0.5),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme(TextTheme textTheme) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      );

  static FilledButtonThemeData _filledButtonTheme(TextTheme textTheme) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(TextTheme textTheme) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme(TextTheme textTheme) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      );

  static const FloatingActionButtonThemeData _fabTheme =
      FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 4,
    shape: CircleBorder(),
  );

  static BottomNavigationBarThemeData _bottomNavTheme(TextTheme textTheme) =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurface.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
      );

  static NavigationBarThemeData _navigationBarTheme(TextTheme textTheme) =>
      NavigationBarThemeData(
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return IconThemeData(
            color: AppColors.onSurface.withValues(alpha: 0.5),
          );
        }),
      );

  static SnackBarThemeData _snackBarTheme(TextTheme textTheme) =>
      SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );

  static ChipThemeData _chipTheme(TextTheme textTheme) => ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        disabledColor: AppColors.onSurface.withValues(alpha: 0.12),
        labelStyle: textTheme.labelMedium?.copyWith(color: AppColors.onSurface),
        secondaryLabelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColors.outline),
        ),
      );

  static ListTileThemeData _listTileTheme(TextTheme textTheme) =>
      ListTileThemeData(
        iconColor: AppColors.onSurface,
        textColor: AppColors.onSurface,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: AppColors.onSurface,
        ),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );

  static const ProgressIndicatorThemeData _progressTheme =
      ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.outlineVariant,
    circularTrackColor: AppColors.outlineVariant,
  );

  static SwitchThemeData get _switchTheme => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.onSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
      );

  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.onPrimary),
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );

  static RadioThemeData get _radioTheme => RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
      );

  static SliderThemeData get _sliderTheme => SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.outlineVariant,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.16),
      );

  static TabBarThemeData _tabBarTheme(TextTheme textTheme) => TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurface.withValues(alpha: 0.5),
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        indicatorColor: AppColors.primary,
        dividerColor: AppColors.outline,
      );

  static TooltipThemeData _tooltipTheme(TextTheme textTheme) => TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: AppColors.onSurface),
      );

  static BottomSheetThemeData _bottomSheetTheme(TextTheme textTheme) =>
      BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      );

  static const DrawerThemeData _drawerTheme = DrawerThemeData(
    backgroundColor: AppColors.surfaceContainer,
    surfaceTintColor: Colors.transparent,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
    ),
  );

  static PopupMenuThemeData _popupMenuTheme(TextTheme textTheme) =>
      PopupMenuThemeData(
        color: AppColors.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.onSurface),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );

  static MaterialBannerThemeData _bannerTheme(TextTheme textTheme) =>
      MaterialBannerThemeData(
        backgroundColor: AppColors.surfaceContainer,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurface,
        ),
      );

  static const BadgeThemeData _badgeTheme = BadgeThemeData(
    backgroundColor: AppColors.premiumAccent,
    textColor: AppColors.onTertiary,
  );

  static DataTableThemeData _dataTableTheme(TextTheme textTheme) =>
      DataTableThemeData(
        headingTextStyle: textTheme.titleSmall?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        dataTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurface,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(12),
        ),
      );

  static ExpansionTileThemeData _expansionTileTheme(TextTheme textTheme) =>
      ExpansionTileThemeData(
        backgroundColor: AppColors.surface,
        collapsedBackgroundColor: AppColors.surface,
        textColor: AppColors.onSurface,
        collapsedTextColor: AppColors.onSurface,
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.onSurface,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      );

  static const ScrollbarThemeData _scrollbarTheme = ScrollbarThemeData(
    thumbColor: WidgetStatePropertyAll(AppColors.outline),
    trackColor: WidgetStatePropertyAll(AppColors.outlineVariant),
    radius: Radius.circular(8),
    thickness: WidgetStatePropertyAll(6),
  );

  static const TextSelectionThemeData _textSelectionTheme =
      TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: Color(0x401D9E75),
    selectionHandleColor: AppColors.primary,
  );
}
