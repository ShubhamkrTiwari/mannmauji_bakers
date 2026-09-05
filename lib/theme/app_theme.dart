import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Warm Artisanal Bakery Palette (Light Brown + Creamy Light-White)
  static const Color zeptoPurple = Color(0xFF5D3A29);       // Rich Warm Cocoa/Light Brown
  static const Color zeptoPurpleDark = Color(0xFF3E2317);   // Deep Roasted Espresso
  static const Color zeptoPurpleLight = Color(0xFF8B5A3C);  // Warm Caramel Light Brown
  static const Color zeptoGreen = Color(0xFF1E7B4A);        // Gourmet Forest Green for ADD & ETA
  static const Color zeptoGreenLight = Color(0xFFEAF4EE);   // Crisp Light Green Tag / ADD BG
  static const Color zeptoPink = Color(0xFFE05A47);         // Warm Coral Offer Tag
  static const Color zeptoBackground = Color(0xFFFAF6F0);   // Soft Creamy Light-White Background
  static const Color zeptoCardBorder = Color(0xFFE8DFD8);   // Subtle warm off-white border
  static const Color zeptoTextPrimary = Color(0xFF2C1A11);  // Deep Warm Espresso Text
  static const Color zeptoTextSecondary = Color(0xFF7A685D);// Subtitle / Warm Gray Text

  // Light Brown & Cream Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5A3C), Color(0xFF5D3A29)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF6C3B2A), Color(0xFF3E2317)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D6A4F), Color(0xFF1E7B4A)],
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFDF9), Color(0xFFFAF6F0)],
  );

  // Legacy Aliases
  static const Color navyPrimary = Color(0xFF5D3A29);
  static const Color navySecondary = Color(0xFF3E2317);
  static const Color goldAccent = Color(0xFF1E7B4A);
  static const Color goldLight = Color(0xFFEAF4EE);
  static const Color creamBackground = Color(0xFFFAF6F0);
  static const Color warmBrown = Color(0xFF7A685D);
  static const Color softRed = Color(0xFFE05A47);
  static const Color successGreen = Color(0xFF1E7B4A);
  
  // Dark mode colors
  static const Color darkBackground = Color(0xFF1A1412);
  static const Color darkSurface = Color(0xFF261D1A);
  static const Color darkCard = Color(0xFF302420);
}

class AppTheme {
  // Standardized Font Family: Plus Jakarta Sans
  static String get fontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.zeptoBackground,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.zeptoPurple,
      primary: AppColors.zeptoPurple,
      secondary: AppColors.zeptoGreen,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.zeptoTextPrimary, letterSpacing: -0.5),
      displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.zeptoTextPrimary, letterSpacing: -0.5),
      displaySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.zeptoTextPrimary),
      headlineLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.zeptoTextPrimary, letterSpacing: -0.3),
      headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.zeptoTextPrimary),
      headlineSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.zeptoTextPrimary),
      titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.zeptoTextPrimary, fontSize: 18),
      titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.zeptoTextPrimary, fontSize: 15),
      titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.zeptoTextPrimary, fontSize: 13),
      bodyLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppColors.zeptoTextPrimary, fontSize: 14),
      bodyMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: AppColors.zeptoTextSecondary, fontSize: 13),
      bodySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: AppColors.zeptoTextSecondary, fontSize: 11),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.zeptoPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.2,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.zeptoCardBorder, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.zeptoGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.zeptoPurpleLight,
      primary: AppColors.zeptoPurpleLight,
      secondary: AppColors.zeptoGreen,
      surface: AppColors.darkSurface,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
      displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
      displaySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
      headlineLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3),
      headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
      titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15),
      titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.grey[300], fontSize: 13),
      bodyLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
      bodyMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: Colors.grey[400], fontSize: 13),
      bodySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: Colors.grey[500], fontSize: 11),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.2,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.zeptoGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static PreferredSizeWidget buildGradientAppBar({
    required BuildContext context,
    required Widget title,
    List<Widget>? actions,
    bool automaticallyImplyLeading = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: title,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(colors: [AppColors.darkSurface, AppColors.darkSurface])
              : AppColors.primaryGradient,
        ),
      ),
    );
  }
}

// Custom smooth page route builder with fade + slide
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  CustomPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.05, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            var fadeAnimation = CurvedAnimation(parent: animation, curve: curve);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}
