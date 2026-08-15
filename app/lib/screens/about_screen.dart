import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: const Color(0xFF078930),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Fidel Crossword Ethiopia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Learn • Play • Celebrate Ethiopian Fidel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const _AboutCard(
                    icon: Icons.school_rounded,
                    title: 'Learn Fidel',
                    text:
                        'Explore Ethiopian Fidel families in their correct seven-letter order and listen to pronunciation.',
                  ),
                  const SizedBox(height: 12),
                  const _AboutCard(
                    icon: Icons.extension_rounded,
                    title: 'Play Crosswords',
                    text:
                        'Practice each Fidel family through simple crossword puzzles, scoring and progress.',
                  ),
                  const SizedBox(height: 12),
                  const _AboutCard(
                    icon: Icons.emoji_events_rounded,
                    title: 'Build Confidence',
                    text:
                        'Move through the families and challenges while learning through play.',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Color(0xFF78909C),
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

class _AboutCard extends StatelessWidget {
  const _AboutCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 34, color: const Color(0xFF078930)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          color: const Color(0xFF546E7A),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
