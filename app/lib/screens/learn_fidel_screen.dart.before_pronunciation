import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../app/app_settings.dart';
import '../fidel_families.dart';

class LearnFidelScreen extends StatefulWidget {
  const LearnFidelScreen({super.key});

  @override
  State<LearnFidelScreen> createState() => _LearnFidelScreenState();
}

class _LearnFidelScreenState extends State<LearnFidelScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _selectedFamilyIndex = 0;
  String? _selectedLetter;
  bool _isPlaying = false;

  List<String> get _selectedFamily => fidelFamilies[_selectedFamilyIndex];

  String _audioFileForLetter(String letter) {
    final int code = letter.runes.first;
    final String unicode = code.toRadixString(16).toLowerCase();

    // These families have later verified replacement recordings.
    final bool usesWavFix =
        (code >= 0x1238 && code <= 0x123e) || // ሸ family
        (code >= 0x12f0 && code <= 0x12f6) || // ደ family
        (code >= 0x1300 && code <= 0x1306) || // ጀ family
        (code >= 0x1338 && code <= 0x133e); // ጸ family

    return 'sounds/fidel_$unicode.${usesWavFix ? 'wav' : 'm4a'}';
  }

  Future<void> _playLetter(String letter) async {
    if (!AppSettings.soundEnabled.value) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Sound is turned off in Settings.')),
        );
      return;
    }

    setState(() {
      _selectedLetter = letter;
      _isPlaying = true;
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(_audioFileForLetter(letter)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('The sound for $letter could not be played.'),
            duration: const Duration(seconds: 2),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _selectFamily(int index) {
    setState(() {
      _selectedFamilyIndex = index;
      _selectedLetter = null;
    });
  }

  void _selectPreviousFamily() {
    _selectFamily(
      _selectedFamilyIndex == 0
          ? fidelFamilies.length - 1
          : _selectedFamilyIndex - 1,
    );
  }

  void _selectNextFamily() {
    _selectFamily(
      _selectedFamilyIndex == fidelFamilies.length - 1
          ? 0
          : _selectedFamilyIndex + 1,
    );
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
      appBar: AppBar(title: const Text('Learn Fidel'), centerTitle: true),
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
                'Tap each Fidel letter to hear its sound.',
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
                  final bool isSelected = _selectedLetter == letter;

                  return Semantics(
                    button: true,
                    label: 'Fidel letter $letter',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _playLetter(letter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              letter,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 58,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              isSelected && _isPlaying
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_down_rounded,
                              size: 24,
                              color: Colors.black87,
                            ),
                          ],
                        ),
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
                separatorBuilder: (_, __) => const SizedBox(width: 8),
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
