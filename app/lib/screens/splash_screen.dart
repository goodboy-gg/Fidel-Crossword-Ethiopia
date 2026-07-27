import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_routes.dart';

import '../game_progress.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override

  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override

  void initState() {

    super.initState();

    _openApp();

  }

  Future<void> _openApp() async {

    await GameProgress.loadProgress();

    await Future<void>.delayed(

      const Duration(seconds: 2),

    );

    if (!mounted) {

      return;

    }

    Navigator.pushReplacementNamed(

      context,

      AppRoutes.home,

    );

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(

        child: Center(

          child: Padding(

            padding: const EdgeInsets.all(24),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                Container(

                  width: 110,

                  height: 110,

                  decoration: BoxDecoration(

                    color: const Color(0xFF078930),

                    borderRadius: BorderRadius.circular(30),

                    boxShadow: <BoxShadow>[

                      BoxShadow(

                        color: Colors.black.withOpacity(0.16),

                        blurRadius: 18,

                        offset: const Offset(0, 9),

                      ),

                    ],

                  ),

                  child: const Icon(

                    Icons.grid_view_rounded,

                    size: 58,

                    color: Colors.white,

                  ),

                ),

                const SizedBox(height: 28),

                const Text(

                  'Fidel Crossword Ethiopia',

                  textAlign: TextAlign.center,

                  style: TextStyle(

                    color: Color(0xFF172033),

                    fontSize: 28,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 10),

                const Text(

                  'Learn Ethiopian Fidel through play.',

                  textAlign: TextAlign.center,

                  style: TextStyle(

                    color: Color(0xFF607D8B),

                    fontSize: 16,

                  ),

                ),

                const SizedBox(height: 28),

                const SizedBox(

                  width: 34,

                  height: 34,

                  child: CircularProgressIndicator(

                    color: Color(0xFF078930),

                    strokeWidth: 4,

                  ),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}