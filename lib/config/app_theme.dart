import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Casheva Design System — ported from website styles.css oklch values
class AppTheme {
  AppTheme._();

  // ── Primary Colors (military green) ──
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryForeground = Color(0xFFF5F5F0);
  static const Color primarySoft = Color(0xFFE8F5E9);

  // ── Gold (military accent) ──
  static const Color gold = Color(0xFFB8860B);
  static const Color goldForeground = Color(0xFFFFFDE7);
  static const Color goldSoft = Color(0xFFFFF8E1);

  // ── Success ──
  static const Color success = Color(0xFF2E7D32);
  static const Color successForeground = Color(0xFFF5FAF5);

  // ── Destructive ──
  static const Color destructive = Color(0xFFD32F2F);
  static const Color destructiveForeground = Color(0xFFFFF5F5);

  // ── Light Mode ──
  static const Color background = Color(0xFFF8FAF8);
  static const Color foreground = Color(0xFF1A2E1A);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF1A2E1A);
  static const Color muted = Color(0xFFF1F5F1);
  static const Color mutedForeground = Color(0xFF6B7B6B);
  static const Color border = Color(0xFFE0E8E0);
  static const Color inputBorder = Color(0xFFE0E8E0);

  // ── Semantic Aliases ──
  static const Color textPrimary = foreground;
  static const Color textSecondary = mutedForeground;
  static const Color textMuted = mutedForeground;
  static const Color primaryDark = Color(0xFF123E17);
  static const Color danger = destructive;

  // ── Sidebar (dark green) ──
  static const Color sidebar = Color(0xFF1A3320);
  static const Color sidebarForeground = Color(0xFFE8F0E8);
  static const Color sidebarAccent = Color(0xFF264D30);
  static const Color sidebarBorder = Color(0xFF2D5A38);

  // ── Chart Colors ──
  static const Color chart1 = Color(0xFF2E7D32);
  static const Color chart2 = Color(0xFFB8860B);
  static const Color chart3 = Color(0xFF1565C0);
  static const Color chart4 = Color(0xFF43A047);
  static const Color chart5 = Color(0xFFD84315);

  // ── Accent (warm gold) ──
  static const Color accent = Color(0xFFFFF3E0);
  static const Color accentForeground = Color(0xFF5D4037);

  // ── Secondary ──
  static const Color secondary = Color(0xFFEFF5EF);
  static const Color secondaryForeground = Color(0xFF264D30);

  // ── Dark Mode ──
  static const Color darkBackground = Color(0xFF121E14);
  static const Color darkForeground = Color(0xFFE8F0E8);
  static const Color darkCard = Color(0xFF1A2E1C);
  static const Color darkCardForeground = Color(0xFFE8F0E8);
  static const Color darkMuted = Color(0xFF233828);
  static const Color darkMutedForeground = Color(0xFFA0B8A0);
  static const Color darkBorder = Color(0xFF2A4030);
  static const Color darkPrimary = Color(0xFF4CAF50);
  static const Color darkPrimarySoft = Color(0xFF1B3A20);
  static const Color darkGold = Color(0xFFDAA520);
  static const Color darkGoldSoft = Color(0xFF3A2E10);
  static const Color darkSuccess = Color(0xFF66BB6A);
  static const Color darkDestructive = Color(0xFFEF5350);

  /// Build the light theme
  static ThemeData lightTheme() {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        surface: card,
        onSurface: foreground,
        error: destructive,
        onError: destructiveForeground,
        outline: border,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border.withValues(alpha: 0.8)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: destructive),
        ),
        hintStyle: textTheme.bodyMedium
            ?.copyWith(color: mutedForeground, fontSize: 13),
        labelStyle: textTheme.bodySmall
            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          elevation: 2,
          shadowColor: primary.withValues(alpha: 0.25),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: muted,
        labelStyle: textTheme.labelSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: border.withValues(alpha: 0.5)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: primary,
        unselectedItemColor: mutedForeground,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: sidebar,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: primaryForeground,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: foreground,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: card),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: mutedForeground,
        indicatorColor: primary,
        labelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: textTheme.labelMedium,
      ),
    );
  }
}
