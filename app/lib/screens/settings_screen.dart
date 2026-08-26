import 'package:flutter/material.dart';

import '../app/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: <Widget>[
            ValueListenableBuilder<bool>(
              valueListenable: AppSettings.soundEnabled,
              builder: (context, enabled, _) {
                return _SwitchCard(
                  icon: enabled
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  title: 'Sound',
                  description:
                      'Play Fidel pronunciation and puzzle-complete sounds.',
                  value: enabled,
                  onChanged: AppSettings.setSound,
                );
              },
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: AppSettings.largeTextEnabled,
              builder: (context, enabled, _) {
                return _SwitchCard(
                  icon: Icons.text_fields_rounded,
                  title: 'Larger text',
                  description:
                      'Increase interface text size for easier reading.',
                  value: enabled,
                  onChanged: AppSettings.setLargeText,
                );
              },
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Icons.translate_rounded,
              title: 'Language',
              description:
                  'English interface with Ethiopian Fidel letters in their correct family order.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Icons.format_list_numbered_rounded,
              title: 'Fidel order',
              description:
                  'All 33 families follow the seven-letter learning order from 1 to 7.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Icons.save_rounded,
              title: 'Progress',
              description:
                  'Your most recently selected level is saved automatically.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Fidel Crossword Ethiopia • Version 1.0.0',
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

class _SwitchCard extends StatelessWidget {
  const _SwitchCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        secondary: _IconBox(icon: icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _IconBox(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      height: 1.4,
                      color: Color(0xFF546E7A),
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

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: const Color(0xFF078930)),
    );
  }
}
