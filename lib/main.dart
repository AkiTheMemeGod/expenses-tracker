import 'package:flutter/material.dart';
import 'package:expenses_tracker/pages/home_page.dart';
import 'package:expenses_tracker/theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF0EA5A5); // Teal accent

    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    final baseInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: lightColorScheme.outlineVariant),
    );

    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Expenses Tracker',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeController.instance.mode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            scaffoldBackgroundColor: const Color(0xFFF7F7FA),
            fontFamily: 'Roboto',
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: lightColorScheme.surface,
              foregroundColor: lightColorScheme.onSurface,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: lightColorScheme.onPrimary,
                backgroundColor: lightColorScheme.primary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(12),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: baseInputBorder,
              enabledBorder: baseInputBorder,
              focusedBorder: baseInputBorder.copyWith(
                borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
              ),
              labelStyle: TextStyle(color: lightColorScheme.onSurfaceVariant),
            ),
            chipTheme: ChipThemeData(
              selectedColor: lightColorScheme.primary.withValues(alpha: 0.12),
              side: BorderSide(color: lightColorScheme.outlineVariant),
              shape: StadiumBorder(side: BorderSide(color: lightColorScheme.outlineVariant)),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: lightColorScheme.surface,
              selectedItemColor: lightColorScheme.primary,
              unselectedItemColor: lightColorScheme.onSurfaceVariant,
              elevation: 8,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            canvasColor: Colors.black,
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: darkColorScheme.primary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF0D0D0D),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(12),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF111111),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: baseInputBorder,
              enabledBorder: baseInputBorder,
              focusedBorder: baseInputBorder.copyWith(
                borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
              ),
              labelStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
            ),
            chipTheme: ChipThemeData(
              backgroundColor: const Color(0xFF121212),
              selectedColor: darkColorScheme.primary.withValues(alpha: 0.18),
              side: BorderSide(color: Colors.white10),
              shape: const StadiumBorder(),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              elevation: 8,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          home: const HomePage(initialIndex: 0),
        );
      },
    );
  }
}
