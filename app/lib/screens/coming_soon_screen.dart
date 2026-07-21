import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {

  const PlaceholderScreen({

    required this.title,

    required this.icon,

    required this.message,

    super.key,

  });

  final String title;

  final IconData icon;

  final String message;

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(title),

      ),

      body: SafeArea(

        child: Center(

          child: Padding(

            padding: const EdgeInsets.all(28),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Icon(

                  icon,

                  size: 82,

                  color: const Color(0xFF078930),

                ),

                const SizedBox(height: 24),

                Text(

                  title,

                  textAlign: TextAlign.center,

                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(

                        fontWeight: FontWeight.bold,

                      ),

                ),

                const SizedBox(height: 16),

                Text(

                  message,

                  textAlign: TextAlign.center,

                  style: Theme.of(context).textTheme.bodyLarge,

                ),

                const SizedBox(height: 28),

                ElevatedButton.icon(

                  onPressed: () {

                    Navigator.pop(context);

                  },

                  icon: const Icon(Icons.arrow_back_rounded),

                  label: const Text('Return'),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}