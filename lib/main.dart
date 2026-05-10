import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF7F9FF),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class AppColors {
  static const background  = Color(0xFFF7F9FF);
  static const surface     = Color(0xFFFFFFFF);
  static const surfaceAlt  = Color(0xFFEFF6FF);
  static const border      = Color(0xFFCBD5E1);
  static const gold        = Color(0xFF1D4ED8);
  static const goldLight   = Color(0xFF60A5FA);
  static const goldDark    = Color(0xFF1E40AF);
  static const goldSurface = Color(0xFFD6E4FF);
  static const goldBorder  = Color(0xFF93C5FD);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecond  = Color(0xFF334155);
  static const textMuted   = Color(0xFF64748B);
  static const textHint    = Color(0xFF94A3B8);

  static const blue        = Color(0xFF2563EB);
  static const blueLight   = Color(0xFF60A5FA);
  static const blueDark    = Color(0xFF1D4ED8);
  static const blueSurface = Color(0xFFE0F2FE);
  static const blueBorder  = Color(0xFF93C5FD);
  static const cyan        = Color(0xFF22D3EE);
  static const cyanLight   = Color(0xFF67E8F9);
  static const cyanSurface = Color(0xFFE0F2FE);
  static const cyanBorder  = Color(0xFF7DD3FC);

  static const accentTeal   = Color(0xFF6AD3D1);
  static const accentPurple = Color(0xFF8D86FF);
  static const accentCoral  = Color(0xFF69A1FF);
  static const accentBlue   = Color(0xFF378ADD);
  static const accentPink   = Color(0xFFD4537E);

  static const List<Color> userColors = [
    accentTeal, accentPurple, accentCoral, accentBlue, accentPink,
    Color(0xFF639922), Color(0xFFBA7517), Color(0xFF185FA5),
    Color(0xFF993556), Color(0xFF0F6E56),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.blue,
          secondary: AppColors.cyan,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.blueDark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE24B4A)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE24B4A), width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIconColor: AppColors.textMuted,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.2,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gold,
            side: const BorderSide(color: AppColors.goldBorder),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.2,
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surface,
          contentTextStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            side: const BorderSide(color: AppColors.border),
          ),
          elevation: 0,
        ),
        dividerColor: AppColors.border,
      ),
      home: const HomePage(),
    );
  }
}