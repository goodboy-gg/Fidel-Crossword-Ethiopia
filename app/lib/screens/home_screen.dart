import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import 'beginner_fidel_practice_screen.dart';
import 'family_starter_challenge_screen.dart';
import 'fidel_pronunciation_practice_screen.dart';
import 'learn_fidel_screen.dart';
import 'mixed_level3_challenge_screen.dart';

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
                children: <Widget>[
                  const _HomeHeader(),
                  const SizedBox(height: 30),
                  _MenuButton(
                    icon: Icons.school_rounded,
                    title: 'Begin Learning Fidel',
                    subtitle: 'Step 1: See, copy and place all 231 letters',
                    backgroundColor: ethiopianGreen,
                    foregroundColor: Colors.white,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const BeginnerFidelPracticeScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.volume_up_rounded,
                    title: 'Learn Fidel Sounds',
                    subtitle: 'Step 2: Hear each Fidel letter',
                    backgroundColor: ethiopianGold,
                    foregroundColor: Colors.black87,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const LearnFidelScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.grid_view_rounded,
                    title: 'Easy Fidel Crosswords',
                    subtitle: 'Step 3: Practise all 33 families',
                    backgroundColor: ethiopianRed,
                    foregroundColor: Colors.white,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.levels),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.shuffle_rounded,
                    title: 'Mixed Fidel Challenge',
                    subtitle: 'Step 4: Mix the seven family starters',
                    backgroundColor: const Color(0xFF9D0B11),
                    foregroundColor: Colors.white,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const MixedLevel3ChallengeScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.extension_rounded,
                    title: 'Challenge Yourself',
                    subtitle: 'Final challenge: Put all 33 Fidel families in order',
                    backgroundColor: const Color(0xFF6A1B9A),
                    foregroundColor: Colors.white,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const FamilyStarterChallengeScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.record_voice_over_rounded,
                    title: '231 Fidel Pronunciation Practice',
                    subtitle: 'Listen, match and place every Fidel letter',
                    backgroundColor: const Color(0xFF512DA8),
                    foregroundColor: Colors.white,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            const FidelPronunciationPracticeScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle: 'Sound, text size and app preferences',
                    backgroundColor: const Color(0xFF263238),
                    foregroundColor: Colors.white,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    icon: Icons.info_rounded,
                    title: 'About',
                    subtitle: 'Learn about Fidel Crossword Ethiopia',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF263238),
                    borderColor: const Color(0xFFCFD8DC),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.about),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'See • Hear • Practice • Mix • Master',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF546E7A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
      children: <Widget>[
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: HomeScreen.ethiopianGreen,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Color(0x26000000), blurRadius: 16,
                  offset: Offset(0, 8)),
            ],
          ),
          child: const Icon(Icons.grid_view_rounded,
              size: 48, color: Colors.white),
        ),
        const SizedBox(height: 18),
        Text('Fidel Crossword Ethiopia',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B1B1B),
          )),
        const SizedBox(height: 8),
        const Text('Start from the beginning and grow into a Fidel master.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF607D8B), fontSize: 16)),
        const SizedBox(height: 18),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: const Row(children: <Widget>[
            Expanded(child: ColoredBox(color: HomeScreen.ethiopianGreen,
                child: SizedBox(height: 8))),
            Expanded(child: ColoredBox(color: HomeScreen.ethiopianGold,
                child: SizedBox(height: 8))),
            Expanded(child: ColoredBox(color: HomeScreen.ethiopianRed,
                child: SizedBox(height: 8))),
          ]),
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
          child: Row(children: <Widget>[
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
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: TextStyle(color: foregroundColor,
                    fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(
                    color: foregroundColor.withValues(alpha: 0.78), fontSize: 14)),
              ],
            )),
            Icon(Icons.arrow_forward_ios_rounded,
                color: foregroundColor.withValues(alpha: 0.75), size: 18),
          ]),
        ),
      ),
    );
  }
}
