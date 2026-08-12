import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../fidel_families.dart';
import 'challenge_crossword_screen.dart';

class Level2PronunciationScreen extends StatefulWidget {
  const Level2PronunciationScreen({super.key});

  @override
  State<Level2PronunciationScreen> createState() =>
      _Level2PronunciationScreenState();
}

class _Level2PronunciationScreenState extends State<Level2PronunciationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  List<String> get _family => fidelFamilies[1];

  Future<void> _playPronunciation() async {
    if (_isPlaying) return;

    setState(() => _isPlaying = true);

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(const AssetSource('sounds/fidel_1208.m4a'));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('The Level 2 pronunciation recording is not available.'),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  void _startLevel2() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const ChallengeCrosswordScreen(level: 2),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 2 — ለ Family'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Listen and learn the ለ family',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Level 2 is the pronunciation level. Listen to the family recording, study the seven forms, then start the crossword.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: _family.map((String letter) {
                              return Container(
                                width: 68,
                                height: 68,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  letter,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _playPronunciation,
                            icon: Icon(
                              _isPlaying
                                  ? Icons.volume_up_rounded
                                  : Icons.play_circle_fill_rounded,
                            ),
                            label: const Text('Play ለ pronunciation'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _startLevel2,
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('Start Level 2 Crossword'),
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
