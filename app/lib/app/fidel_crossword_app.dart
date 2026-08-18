import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_routes.dart';
import 'app_settings.dart';

class FidelCrosswordApp extends StatelessWidget {
  const FidelCrosswordApp({super.key});

  static const Color ethiopianGreen = Color(0xFF078930);
  static const Color ethiopianGold = Color(0xFFFCDD09);
  static const Color ethiopianRed = Color(0xFFDA121A);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.largeTextEnabled,
      builder: (context, largeText, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fidel Crossword Ethiopia',
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            colorScheme: ColorScheme.fromSeed(
              seedColor: ethiopianGreen,
              primary: ethiopianGreen,
              secondary: ethiopianGold,
              error: ethiopianRed,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: ethiopianGreen,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: ethiopianGreen,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          builder: (context, child) {
            final MediaQueryData mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(largeText ? 1.15 : 1.0),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
