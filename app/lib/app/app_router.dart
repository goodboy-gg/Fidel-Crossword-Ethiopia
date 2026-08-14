import 'package:flutter/material.dart';

import '../screens/coming_soon_screen.dart';
import '../screens/crossword_screen.dart';
import '../screens/home_screen.dart';
import '../screens/level3_mixed_crossword_screen.dart';
import '../screens/levels_screen.dart';
import '../screens/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.levels:
        return MaterialPageRoute<void>(
          builder: (_) => const LevelsScreen(),
          settings: settings,
        );
      case AppRoutes.crossword:
        final Object? argument = settings.arguments;
        final int level = argument is int ? argument : 1;
        final RouteSettings crosswordSettings = RouteSettings(
          name: AppRoutes.crossword,
          arguments: level,
        );

        return MaterialPageRoute<void>(
          builder: (_) => level == 3
              ? const Level3MixedCrosswordScreen()
              : const CrosswordScreen(),
          settings: crosswordSettings,
        );
      case AppRoutes.placeholder:
        return MaterialPageRoute<void>(
          builder: (_) => const PlaceholderScreen(
            title: 'Coming Soon',
            message: 'This feature is being prepared.',
            icon: Icons.construction_rounded,
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
