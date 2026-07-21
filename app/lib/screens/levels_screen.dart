import 'package:flutter/material.dart';

import '../app/app_routes.dart';

class LevelsScreen extends StatelessWidget {

  const LevelsScreen({super.key});

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Choose a Level'),

      ),

      body: GridView.builder(

        padding: const EdgeInsets.all(20),

        itemCount: 12,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 3,

          mainAxisSpacing: 14,

          crossAxisSpacing: 14,

        ),

        itemBuilder: (context, index) {

          final int level = index + 1;

          final bool unlocked = level <= 4;

          return InkWell(

            borderRadius: BorderRadius.circular(16),

            onTap: unlocked

                ? () {

                    Navigator.pushNamed(

                      context,

                      AppRoutes.crossword,

                      arguments: level,

                    );

                  }

                : () {

                    ScaffoldMessenger.of(context).showSnackBar(

                      SnackBar(

                        content: Text(

                          'Complete earlier levels to unlock Level $level.',

                        ),

                      ),

                    );

                  },

            child: Card(

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Icon(

                    unlocked

                        ? Icons.lock_open_rounded

                        : Icons.lock_rounded,

                    color: unlocked

                        ? const Color(0xFF078930)

                        : Colors.grey,

                  ),

                  const SizedBox(height: 8),

                  Text(

                    '$level',

                    style: const TextStyle(

                      fontSize: 26,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  Text(

                    unlocked ? 'Open' : 'Locked',

                    style: TextStyle(

                      color: unlocked

                          ? const Color(0xFF078930)

                          : Colors.grey,

                    ),

                  ),

                ],

              ),

            ),

          );

        },

      ),

    );

  }

}

