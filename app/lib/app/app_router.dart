import 'package:flutter/material.dart';

import '../screens/about_screen.dart';
import '../screens/coming_soon_screen.dart';
import '../screens/settings_screen.dart';

import '../screens/home_screen.dart';

import '../screens/levels_screen.dart';

import '../screens/splash_screen.dart';
import '../screens/crossword_screen.dart';
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

          builder: (_) => const CrosswordScreen(),

            

          settings: settings,

        );

      case AppRoutes.settings:

        return MaterialPageRoute(

          builder: (_) => const SettingsScreen(),

          settings: settings,

        );

      case AppRoutes.about:

        return MaterialPageRoute(

          builder: (_) => const AboutScreen(),

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

