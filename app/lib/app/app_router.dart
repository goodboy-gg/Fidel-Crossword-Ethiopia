import 'package:flutter/material.dart';

import '../screens/coming_soon_screen.dart';

import '../screens/home_screen.dart';

import '../screens/levels_screen.dart';

import '../screens/splash_screen.dart';

import 'app_routes.dart';

class AppRouter {

  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    switch (settings.name) {

      case AppRoutes.splash:

        return MaterialPageRoute(

          builder: (_) => const SplashScreen(),

          settings: settings,

        );

      case AppRoutes.home:

        return MaterialPageRoute(

          builder: (_) => const HomeScreen(),

          settings: settings,

        );

      case AppRoutes.levels:

        return MaterialPageRoute(

          builder: (_) => const LevelsScreen(),

          settings: settings,

        );

      case AppRoutes.crossword:

        return MaterialPageRoute(

          builder: (_) => const PlaceholderScreen(

            title: 'Crossword',

            message: 'The crossword game is being prepared.',

            icon: Icons.grid_4x4_rounded,

          ),

          settings: settings,

        );

      case AppRoutes.placeholder:

        return MaterialPageRoute(

          builder: (_) => const PlaceholderScreen(

            title: 'Coming Soon',

            message: 'This feature is being prepared.',

            icon: Icons.construction_rounded,

          ),

          settings: settings,

        );

      default:

        return MaterialPageRoute(

          builder: (_) => const SplashScreen(),

          settings: settings,

        );

    }

  }

}

