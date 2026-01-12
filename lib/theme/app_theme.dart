import 'package:flutter/material.dart';
import 'dart:ui';

// ============================================================================
// CRYPTOSYARIA - STRICT FIQH MUAMALAH COLOR SYSTEM
// ============================================================================
// PHILOSOPHY:
// - Mature, ethical, calm, intentional, investor-trustworthy
// - Could be used by an Islamic bank or ethical fintech
// - MAX 2 main colors per screen
// - NO rainbow icons, NO playful gradients
// ============================================================================

class MuamalahColors {
  // ============================================
  // BRAND COLORS (AVERROES IDENTITY)
  // ============================================
  static const Color primaryEmerald = Color(0xFF0F766E);   // Averroes Primary (Teal 700)
  static const Color emeraldLight = Color(0xFF115E59);     // Teal 800
  static const Color emeraldDark = Color(0xFF134E4A);      // Teal 900
  
  static const Color secondaryMidnight = Color(0xFF0F172A); // Averroes Secondary (Slate 900)
  
  // ============================================
  // ACCENT - BURNISHED GOLD
  // ============================================
  static const Color accentGold = Color(0xFFD97706);       // Amber 600
  static const Color mutedGold = Color(0xFFD97706);        // Compat alias
  
  // ============================================
  // BACKGROUNDS
  // ============================================
  static const Color backgroundPrimary = Color(0xFFF8FAFC); // Slate 50 (Light Porcelain)
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color neutralBg = Color(0xFFF1F5F9);         // Slate 100
  
  // ============================================
  // TEXT COLORS
  // ============================================
  static const Color textPrimary = Color(0xFF0F172A);       // Slate 900 (High Contrast)
  static const Color textSecondary = Color(0xFF334155);     // Slate 700
  static const Color textMuted = Color(0xFF64748B);         // Slate 500
  
  // ============================================
  // SEMANTIC / STATUS COLORS
  // ============================================
  
  // Halal: Fresh Teal/Emerald
  static const Color halal = Color(0xFF0D9488);             // Teal 600
  static const Color halalBg = Color(0xFFF0FDFA);           // Teal 50
  
  // Proses (Kaji Ulang): Amber/Gold
  static const Color proses = Color(0xFFD97706);           // Amber 600
  static const Color prosesBg = Color(0xFFFFFBEB);         // Amber 50
  
  // Haram/Risk: Rose/Red
  static const Color haram = Color(0xFFE11D48);             // Rose 600
  static const Color haramBg = Color(0xFFFFF1F2);           // Rose 50
  
  // Risiko Tinggi: Red
  static const Color risikoTinggi = Color(0xFFBE123C);      // Rose 700
  static const Color risikoTinggiBg = Color(0xFFFFF1F2);
  
  // ============================================
  // CRYPTO BRAND COLORS
  // ============================================
  static const Color bitcoin = Color(0xFFF59E0B);
  static const Color ethereum = Color(0xFF6366F1);
  static const Color binance = Color(0xFFFBBF24);
  static const Color solana = Color(0xFF8B5CF6);
  static const Color cardano = Color(0xFF3B82F6);
  static const Color ripple = Color(0xFF06B6D4);
  
  // ============================================
  // GLASS & SURFACE
  // ============================================
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassBorder = Color(0xFFE2E8F0);       // Slate 200
  static const Color cardShadow = Color(0x0F0F172A);        // Slate 900 with low opacity
  
  // ============================================
  // LEGACY ALIASES (Backwards Compatibility)
  // ============================================
  static const Color mint = Color(0xFFF0FDFA);              // Teal 50
  static const Color mintSoft = Color(0xFFF8FAFC);
  static const Color cream = Color(0xFFF8FAFC);
  static const Color creamSoft = Color(0xFFF1F5F9);
  static const Color softBlue = Color(0xFFE2E8F0);
  static const Color softBlueDark = Color(0xFFCBD5E1);
  static const Color goldSoft = Color(0xFFFFFBEB);
  static const Color neutral = Color(0xFF64748B);
  static const Color neutralDark = Color(0xFF334155);
  static const Color neutralLight = Color(0xFF94A3B8);
}

// ============================================================================
// MUAMALAH THEME EXTENSION
// ============================================================================

class MuamalahThemeExtension extends ThemeExtension<MuamalahThemeExtension> {
  final Color halalColor;
  final Color halalBackground;
  final Color haramColor;
  final Color haramBackground;
  final Color prosesColor;
  final Color prosesBackground;
  final Color risikoTinggiColor;
  final Color risikoTinggiBackground;
  final Color neutralColor;
  final Color neutralBackground;
  final Color glassBackground;
  final Color glassBorder;
  final Color cardShadowColor;
  final double antiGravitySpreadRadius;
  final double antiGravityBlurRadius;
  final double antiGravityOpacity;

  const MuamalahThemeExtension({
    required this.halalColor,
    required this.halalBackground,
    required this.haramColor,
    required this.haramBackground,
    required this.prosesColor,
    required this.prosesBackground,
    required this.risikoTinggiColor,
    required this.risikoTinggiBackground,
    required this.neutralColor,
    required this.neutralBackground,
    required this.glassBackground,
    required this.glassBorder,
    required this.cardShadowColor,
    required this.antiGravitySpreadRadius,
    required this.antiGravityBlurRadius,
    required this.antiGravityOpacity,
  });

  @override
  MuamalahThemeExtension copyWith({
    Color? halalColor,
    Color? halalBackground,
    Color? haramColor,
    Color? haramBackground,
    Color? prosesColor,
    Color? prosesBackground,
    Color? risikoTinggiColor,
    Color? risikoTinggiBackground,
    Color? neutralColor,
    Color? neutralBackground,
    Color? glassBackground,
    Color? glassBorder,
    Color? cardShadowColor,
    double? antiGravitySpreadRadius,
    double? antiGravityBlurRadius,
    double? antiGravityOpacity,
  }) {
    return MuamalahThemeExtension(
      halalColor: halalColor ?? this.halalColor,
      halalBackground: halalBackground ?? this.halalBackground,
      haramColor: haramColor ?? this.haramColor,
      haramBackground: haramBackground ?? this.haramBackground,
      prosesColor: prosesColor ?? this.prosesColor,
      prosesBackground: prosesBackground ?? this.prosesBackground,
      risikoTinggiColor: risikoTinggiColor ?? this.risikoTinggiColor,
      risikoTinggiBackground: risikoTinggiBackground ?? this.risikoTinggiBackground,
      neutralColor: neutralColor ?? this.neutralColor,
      neutralBackground: neutralBackground ?? this.neutralBackground,
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      cardShadowColor: cardShadowColor ?? this.cardShadowColor,
      antiGravitySpreadRadius: antiGravitySpreadRadius ?? this.antiGravitySpreadRadius,
      antiGravityBlurRadius: antiGravityBlurRadius ?? this.antiGravityBlurRadius,
      antiGravityOpacity: antiGravityOpacity ?? this.antiGravityOpacity,
    );
  }

  @override
  MuamalahThemeExtension lerp(ThemeExtension<MuamalahThemeExtension>? other, double t) {
    if (other is! MuamalahThemeExtension) {
      return this;
    }
    return MuamalahThemeExtension(
      halalColor: Color.lerp(halalColor, other.halalColor, t)!,
      halalBackground: Color.lerp(halalBackground, other.halalBackground, t)!,
      haramColor: Color.lerp(haramColor, other.haramColor, t)!,
      haramBackground: Color.lerp(haramBackground, other.haramBackground, t)!,
      prosesColor: Color.lerp(prosesColor, other.prosesColor, t)!,
      prosesBackground: Color.lerp(prosesBackground, other.prosesBackground, t)!,
      risikoTinggiColor: Color.lerp(risikoTinggiColor, other.risikoTinggiColor, t)!,
      risikoTinggiBackground: Color.lerp(risikoTinggiBackground, other.risikoTinggiBackground, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
      neutralBackground: Color.lerp(neutralBackground, other.neutralBackground, t)!,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      cardShadowColor: Color.lerp(cardShadowColor, other.cardShadowColor, t)!,
      antiGravitySpreadRadius: _lerpDouble(antiGravitySpreadRadius, other.antiGravitySpreadRadius, t)!,
      antiGravityBlurRadius: _lerpDouble(antiGravityBlurRadius, other.antiGravityBlurRadius, t)!,
      antiGravityOpacity: _lerpDouble(antiGravityOpacity, other.antiGravityOpacity, t)!,
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }

  static const MuamalahThemeExtension defaultExtension = MuamalahThemeExtension(
    halalColor: MuamalahColors.halal,
    halalBackground: MuamalahColors.halalBg,
    haramColor: MuamalahColors.haram,
    haramBackground: MuamalahColors.haramBg,
    prosesColor: MuamalahColors.proses,
    prosesBackground: MuamalahColors.prosesBg,
    risikoTinggiColor: MuamalahColors.risikoTinggi,
    risikoTinggiBackground: MuamalahColors.risikoTinggiBg,
    neutralColor: MuamalahColors.neutral,
    neutralBackground: MuamalahColors.neutralBg,
    glassBackground: MuamalahColors.glassWhite,
    glassBorder: MuamalahColors.glassBorder,
    cardShadowColor: MuamalahColors.cardShadow,
    antiGravitySpreadRadius: 8.0,
    antiGravityBlurRadius: 24.0,
    antiGravityOpacity: 0.08,
  );
}

// ============================================================================
// ANTI-GRAVITY CARD DECORATION
// ============================================================================

class AntiGravityDecoration {
  static BoxDecoration floating({
    Color? color,
    double borderRadius = 24.0,
    double spreadRadius = 8.0,
    double blurRadius = 24.0,
    double shadowOpacity = 0.08,
  }) {
    return BoxDecoration(
      color: color ?? MuamalahColors.glassWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((shadowOpacity * 255).round()),
          spreadRadius: spreadRadius,
          blurRadius: blurRadius,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withAlpha((shadowOpacity * 0.5 * 255).round()),
          spreadRadius: spreadRadius * 0.5,
          blurRadius: blurRadius * 0.5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration glass({
    double borderRadius = 24.0,
    double opacity = 0.85,
  }) {
    return BoxDecoration(
      color: Colors.white.withAlpha((opacity * 255).round()),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: MuamalahColors.glassBorder.withAlpha(128),
        width: 1,
      ),
    );
  }
}

// ============================================================================
// APP THEME
// ============================================================================

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: MuamalahColors.primaryEmerald,
        brightness: Brightness.light,
        primary: MuamalahColors.primaryEmerald,
        secondary: MuamalahColors.mint,
        surface: MuamalahColors.backgroundSecondary,
        onPrimary: Colors.white,
        onSecondary: MuamalahColors.textPrimary,
        onSurface: MuamalahColors.textPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: MuamalahColors.backgroundPrimary,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: MuamalahColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: MuamalahColors.textPrimary),
      ),
      
      // Card Theme - Anti-Gravity Styling
      cardTheme: CardThemeData(
        color: MuamalahColors.glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shadowColor: MuamalahColors.cardShadow,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: MuamalahColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: MuamalahColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: MuamalahColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: MuamalahColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: MuamalahColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MuamalahColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MuamalahColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: MuamalahColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: MuamalahColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: MuamalahColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MuamalahColors.textPrimary,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MuamalahColors.glassWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MuamalahColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MuamalahColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MuamalahColors.primaryEmerald, width: 2),
        ),
        hintStyle: const TextStyle(color: MuamalahColors.textMuted),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MuamalahColors.primaryEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MuamalahColors.primaryEmerald,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: MuamalahColors.textSecondary,
        size: 24,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: MuamalahColors.primaryEmerald,
        unselectedItemColor: MuamalahColors.textMuted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
      
      // Extensions
      extensions: const <ThemeExtension<dynamic>>[
        MuamalahThemeExtension.defaultExtension,
      ],
    );
  }
}

// ============================================================================
// GLASSMORPHISM WIDGETS
// ============================================================================

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurX;
  final double blurY;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double opacity;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blurX = 10.0,
    this.blurY = 10.0,
    this.padding,
    this.margin,
    this.opacity = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((opacity * 255).round()),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withAlpha(77),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AntiGravityCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AntiGravityCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: AntiGravityDecoration.floating(
              color: backgroundColor ?? MuamalahColors.glassWhite,
              borderRadius: borderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
