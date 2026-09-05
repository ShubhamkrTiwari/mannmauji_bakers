import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary luxury bakery palette
  static const Color navyPrimary = Color(0xFF0D1B2A);
  static const Color navySecondary = Color(0xFF1B263B);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF4E2BB);
  static const Color creamBackground = Color(0xFFFAF3E0);
  static const Color warmBrown = Color(0xFF8D5B4C);
  static const Color softRed = Color(0xFFB83232);
  static const Color successGreen = Color(0xFF2D6A4F);
  
  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.creamBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navyPrimary,
      primary: AppColors.navyPrimary,
      secondary: AppColors.goldAccent,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.navyPrimary),
      displayMedium: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.navyPrimary),
      displaySmall: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.navyPrimary),
      headlineLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.navyPrimary),
      headlineMedium: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.navyPrimary),
      headlineSmall: GoogleFonts.fraunces(fontWeight: FontWeight.w600, color: AppColors.navyPrimary),
      titleLarge: GoogleFonts.fraunces(fontWeight: FontWeight.w600, color: AppColors.navyPrimary),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.navyPrimary),
      titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.navyPrimary),
      bodyLarge: GoogleFonts.inter(color: AppColors.navyPrimary),
      bodyMedium: GoogleFonts.inter(color: AppColors.navySecondary),
      bodySmall: GoogleFonts.inter(color: Colors.grey[700]),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.navyPrimary,
      foregroundColor: AppColors.goldLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.goldLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navyPrimary,
        foregroundColor: AppColors.goldLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
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
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.goldAccent,
      primary: AppColors.goldAccent,
      secondary: AppColors.goldLight,
      surface: AppColors.darkSurface,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.goldLight),
      displayMedium: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.goldLight),
      displaySmall: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.goldLight),
      headlineLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.goldLight),
      headlineMedium: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: AppColors.goldLight),
      headlineSmall: GoogleFonts.fraunces(fontWeight: FontWeight.w600, color: AppColors.goldLight),
      titleLarge: GoogleFonts.fraunces(fontWeight: FontWeight.w600, color: AppColors.goldLight),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
      titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.grey[300]),
      bodyLarge: GoogleFonts.inter(color: Colors.white),
      bodyMedium: GoogleFonts.inter(color: Colors.grey[300]),
      bodySmall: GoogleFonts.inter(color: Colors.grey[400]),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.goldLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.goldLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.goldAccent,
        foregroundColor: AppColors.navyPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
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
