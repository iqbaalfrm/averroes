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
  // BRAND COLORS (EARTHY & CALM)
  // ============================================
  static const Color primaryEmerald = Color(0xFF155E58);   // Deep Forest/Sage
  static const Color emeraldLight = Color(0xFF2E7D76);     // Softer Sage
  static const Color emeraldDark = Color(0xFF0F4540);      // Deep Green
  
  static const Color secondaryMidnight = Color(0xFF2D2A26); // Warm Charcoal
  
  // ============================================
  // ACCENT - SAND / CLAY
  // ============================================
  static const Color accentGold = Color(0xFFC69C6D);       // Muted Gold/Clay
  static const Color mutedGold = Color(0xFFC69C6D);        
  
  // ============================================
  // BACKGROUNDS
  // ============================================
  static const Color backgroundPrimary = Color(0xFFFAFAF9); // Warm White (Paper)
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color neutralBg = Color(0xFFF5F5F4);        // Warm Grey
  
  // ============================================
  // TEXT COLORS
  // ============================================
  static const Color textPrimary = Color(0xFF2D2A26);       // Warm Charcoal
  static const Color textSecondary = Color(0xFF57534E);     // Warm Grey
  static const Color textMuted = Color(0xFF78716C);         // Stone
  
  // ============================================
  // SEMANTIC / STATUS COLORS (MUTED)
  // ============================================
  
  // Halal: Sage Green
  static const Color halal = Color(0xFF4D8B55);             
  static const Color halalBg = Color(0xFFECFDF5);           
  
  // Proses: Earthy Orange
  static const Color proses = Color(0xFFCA8A04);           
  static const Color prosesBg = Color(0xFFFEF9C3);         
  
  // Haram: Muted Red
  static const Color haram = Color(0xFFBE123C);             
  static const Color haramBg = Color(0xFFFFF1F2);           
  
  // Risiko Tinggi: Deep Red
  static const Color risikoTinggi = Color(0xFF9F1239);      
  static const Color risikoTinggiBg = Color(0xFFFFF1F2);
  
  // ============================================
  // CRYPTO BRAND COLORS (DESATURATED)
  // ============================================
  static const Color bitcoin = Color(0xFFD97706); // Less Neon Orange
  static const Color ethereum = Color(0xFF6366F1); // Blueish purple
  static const Color binance = Color(0xFFEAB308); // Gold
  static const Color solana = Color(0xFF8B5CF6);
  static const Color cardano = Color(0xFF3B82F6);
  static const Color ripple = Color(0xFF06B6D4);
  
  // ============================================
  // GLASS & SURFACE
  // ============================================
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassBorder = Color(0xFFE7E5E4);       // Warm Border
  static const Color cardShadow = Color(0x0D000000);        // Very soft shadow
  
  // ============================================
  // LEGACY ALIASES
  // ============================================
  static const Color mint = Color(0xFFF0FDF4);              
  static const Color mintSoft = Color(0xFFFAFAF9);
  static const Color cream = Color(0xFFFAFAF9);
  static const Color creamSoft = Color(0xFFF5F5F4);
  static const Color softBlue = Color(0xFFE5E5E5);
  static const Color softBlueDark = Color(0xFFD1D5DB);
  static const Color goldSoft = Color(0xFFFFFBEB);
  static const Color neutral = Color(0xFF78716C);
  static const Color neutralDark = Color(0xFF57534E);
  static const Color neutralLight = Color(0xFFA8A29E);
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
    double borderRadius = 20.0, // Slightly reduced radius
    double spreadRadius = 0,
    double blurRadius = 20.0,
    double shadowOpacity = 0.05, // Softer shadow
  }) {
    return BoxDecoration(
      color: color ?? MuamalahColors.glassWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(shadowOpacity),
          spreadRadius: spreadRadius,
          blurRadius: blurRadius,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration glass({
    double borderRadius = 20.0,
    double opacity = 0.9,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: MuamalahColors.glassBorder,
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
