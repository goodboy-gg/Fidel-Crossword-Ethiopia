import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_routes.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override

  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  Timer? _navigationTimer;

  @override

  void initState() {

    super.initState();

    _navigationTimer = Timer(

      const Duration(seconds: 2),

      () {

        if (!mounted) {

          return;

        }

        Navigator.pushReplacementNamed(

          context,

          AppRoutes.home,

        );

      },

    );

  }

  @override

  void dispose() {

    _navigationTimer?.cancel();

    super.dispose();

  }

  @override

  Widget build(BuildContext context) {

    return const Scaffold(

      backgroundColor: Color(0xFF078930),

      body: SafeArea(

        child: Center(

          child: Padding(

            padding: EdgeInsets.all(28),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                CircleAvatar(

                  radius: 56,

                  backgroundColor: Colors.white,

                  child: Text(

                    'ፊ',

                    style: TextStyle(

                      fontSize: 62,

                      fontWeight: FontWeight.bold,

                      color: Color(0xFF078930),

                    ),

                  ),

                ),

                SizedBox(height: 28),

                Text(

                  'Fidel Crossword Ethiopia',

                  textAlign: TextAlign.center,

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 29,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                SizedBox(height: 12),

                Text(

                  'Learn • Play • Discover Ethiopian Fidel',

                  textAlign: TextAlign.center,

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 16,

                  ),

                ),

                SizedBox(height: 38),

                CircularProgressIndicator(

                  color: Color(0xFFFCDD09),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}