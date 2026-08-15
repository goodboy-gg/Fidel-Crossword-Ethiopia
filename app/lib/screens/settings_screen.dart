import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: <Widget>[
            _SettingsCard(
              icon: Icons.volume_up_rounded,
              title: 'Sound',
              description:
                  'Fidel pronunciation and puzzle-complete sounds are enabled.',
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.translate_rounded,
              title: 'Language',
              description:
                  'English interface with Ethiopian Fidel letters in their correct family order.',
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.format_list_numbered_rounded,
              title: 'Fidel order',
              description:
                  'Each family follows the seven-letter learning order from 1 to 7.',
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.save_rounded,
              title: 'Progress',
              description:
                  'Your level progress is saved automatically while you learn and play.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Fidel Crossword Ethiopia',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF607D8B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF078930)),
            ),
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
                    description,
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
