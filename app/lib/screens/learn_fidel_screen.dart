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
  String? _selectedLetter;
  bool _isPlaying = false;

  List<String> get _selectedFamily => fidelFamilies[_selectedFamilyIndex];

  String _audioFileForLetter(String letter) {
    final String unicode = letter.runes.first.toRadixString(16).toLowerCase();
    return 'sounds/fidel_$unicode.m4a';
  }

  Future<void> _playLetter(String letter) async {
    setState(() {
      _selectedLetter = letter;
      _isPlaying = true;
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource(_audioFileForLetter(_selectedFamily.first)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('The sound for ${_selectedFamily.first} family is not available yet.'),
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

  void _selectPreviousFamily() {
    setState(() {
      if (_selectedFamilyIndex == 0) {
        _selectedFamilyIndex = fidelFamilies.length - 1;
      } else {
        _selectedFamilyIndex--;
      }
      _selectedLetter = null;
    });
  }

  void _selectNextFamily() {
    setState(() {
      if (_selectedFamilyIndex == fidelFamilies.length - 1) {
        _selectedFamilyIndex = 0;
      } else {
        _selectedFamilyIndex++;
      }
      _selectedLetter = null;
    });
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
                'Tap any Fidel box to hear this family sound.',
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
                                height: 1.0,
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
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  final bool isSelected = index == _selectedFamilyIndex;

                  return ChoiceChip(
                    selected: isSelected,
                    label: Text('${index + 1}. ${fidelFamilies[index].first}'),
                    onSelected: (_) {
                      setState(() {
                        _selectedFamilyIndex = index;
                        _selectedLetter = null;
                      });
                    },
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
