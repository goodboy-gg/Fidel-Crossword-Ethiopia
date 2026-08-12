import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../fidel_families.dart';

class LearnFidelScreen extends StatefulWidget {
  const LearnFidelScreen({super.key});

  @override
  State<LearnFidelScreen> createState() => _LearnFidelScreenState();
}

class _LearnFidelScreenState extends State<LearnFidelScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _selectedFamilyIndex = 0;
  bool _isPlaying = false;

  List<String> get _selectedFamily => fidelFamilies[_selectedFamilyIndex];

  String get _selectedFamilyAudio {
    final String starter = _selectedFamily.first;
    final String unicode = starter.runes.first.toRadixString(16).toLowerCase();
    return 'sounds/fidel_$unicode.m4a';
  }

  Future<void> _playFamilyPronunciation() async {
    if (_isPlaying) return;

    setState(() => _isPlaying = true);

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(_selectedFamilyAudio));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'The pronunciation for ${_selectedFamily.first} family is not available.',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  void _selectFamily(int index) {
    _audioPlayer.stop();
    setState(() {
      _selectedFamilyIndex = index;
      _isPlaying = false;
    });
  }

  void _selectPreviousFamily() {
    final int index = _selectedFamilyIndex == 0
        ? fidelFamilies.length - 1
        : _selectedFamilyIndex - 1;
    _selectFamily(index);
  }

  void _selectNextFamily() {
    final int index = _selectedFamilyIndex == fidelFamilies.length - 1
        ? 0
        : _selectedFamilyIndex + 1;
    _selectFamily(index);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 2 — Learn Fidel'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Previous family',
                        onPressed: _selectPreviousFamily,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Family ${_selectedFamilyIndex + 1} of $totalFidelFamilies',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedFamily.first,
                              style: const TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: _isPlaying
                                  ? null
                                  : _playFamilyPronunciation,
                              icon: Icon(
                                _isPlaying
                                    ? Icons.volume_up_rounded
                                    : Icons.play_circle_fill_rounded,
                              ),
                              label: Text(
                                _isPlaying
                                    ? 'Playing…'
                                    : 'Play ${_selectedFamily.first} pronunciation',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Next family',
                        onPressed: _selectNextFamily,
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Listen to the family pronunciation, then study its seven Fidel forms.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _selectedFamily.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final String letter = _selectedFamily[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      letter,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 58,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 72,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                scrollDirection: Axis.horizontal,
                itemCount: fidelFamilies.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  final bool isSelected = index == _selectedFamilyIndex;
                  return ChoiceChip(
                    selected: isSelected,
                    label: Text('${index + 1}. ${fidelFamilies[index].first}'),
                    onSelected: (_) => _selectFamily(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
