import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import 'family_starter_challenge_screen.dart';
import 'learn_fidel_screen.dart';
import 'level3_mixed_crossword_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color ethiopianGreen = Color(0xFF078930);

  static const Color ethiopianGold = Color(0xFFFCDD09);

  static const Color ethiopianRed = Color(0xFFDA121A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  const _HomeHeader(),

                  const SizedBox(height: 30),

                  _MenuButton(
                    icon: Icons.play_arrow_rounded,

                    title: 'Start Game',

                    subtitle: 'Begin a new Fidel crossword',

                    backgroundColor: ethiopianGreen,

                    foregroundColor: Colors.white,

                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.crossword,
                        arguments: 1,
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    icon: Icons.menu_book_rounded,

                    title: 'Learn Fidel',

                    subtitle: 'Study Ethiopian letters and sounds',

                    backgroundColor: ethiopianGold,

                    foregroundColor: Colors.black87,

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return const LearnFidelScreen();
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    icon: Icons.emoji_events_rounded,

                    title: 'Level 3 — Challenge',

                    subtitle: 'Mixed Fidel crossword',

                    backgroundColor: ethiopianRed,

                    foregroundColor: Colors.white,

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return const Level3MixedCrosswordScreen();
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    icon: Icons.extension_rounded,

                    title: 'Challenge Yourself',

                    subtitle: 'Put all 33 Fidel families in order',

                    backgroundColor: const Color(0xFF6A1B9A),

                    foregroundColor: Colors.white,

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return const FamilyStarterChallengeScreen();
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    icon: Icons.settings_rounded,

                    title: 'Settings',

                    subtitle: 'Sound, language and preferences',

                    backgroundColor: const Color(0xFF263238),

                    foregroundColor: Colors.white,

                    onPressed: () {
                      Navigator.pushNamed(
                        context,

                        AppRoutes.placeholder,

                        arguments: 'Settings',
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    icon: Icons.info_rounded,

                    title: 'About',

                    subtitle: 'Learn about Fidel Crossword Ethiopia',

                    backgroundColor: Colors.white,

                    foregroundColor: const Color(0xFF263238),

                    borderColor: const Color(0xFFCFD8DC),

                    onPressed: () {
                      Navigator.pushNamed(
                        context,

                        AppRoutes.placeholder,

                        arguments: 'About',
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Learn • Play • Celebrate Ethiopian Fidel',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Color(0xFF546E7A),

                      fontSize: 14,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,

          height: 92,

          decoration: BoxDecoration(
            color: HomeScreen.ethiopianGreen,

            borderRadius: BorderRadius.circular(26),

            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),

                blurRadius: 16,

                offset: Offset(0, 8),
              ),
            ],
          ),

          child: const Icon(
            Icons.grid_view_rounded,

            size: 48,

            color: Colors.white,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Fidel Crossword Ethiopia',

          textAlign: TextAlign.center,

          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,

            color: const Color(0xFF1B1B1B),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Discover Ethiopian Fidel through learning and play.',

          textAlign: TextAlign.center,

          style: TextStyle(color: Color(0xFF607D8B), fontSize: 16),
        ),

        const SizedBox(height: 18),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: const Row(
            children: [
              Expanded(
                child: ColoredBox(
                  color: HomeScreen.ethiopianGreen,

                  child: SizedBox(height: 8),
                ),
              ),

              Expanded(
                child: ColoredBox(
                  color: HomeScreen.ethiopianGold,

                  child: SizedBox(height: 8),
                ),
              ),

              Expanded(
                child: ColoredBox(
                  color: HomeScreen.ethiopianRed,

                  child: SizedBox(height: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,

    required this.title,

    required this.subtitle,

    required this.backgroundColor,

    required this.foregroundColor,

    required this.onPressed,

    this.borderColor,
  });

  final IconData icon;

  final String title;

  final String subtitle;

  final Color backgroundColor;

  final Color foregroundColor;

  final Color? borderColor;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),

        side: BorderSide(color: borderColor ?? Colors.transparent),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onPressed,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),

          child: Row(
            children: [
              Container(
                width: 50,

                height: 50,

                decoration: BoxDecoration(
                  color: foregroundColor.withValues(alpha: 0.14),

                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(icon, color: foregroundColor, size: 29),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        color: foregroundColor,

                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      style: TextStyle(
                        color: foregroundColor.withValues(alpha: 0.78),

                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,

                color: foregroundColor.withValues(alpha: 0.75),

                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
