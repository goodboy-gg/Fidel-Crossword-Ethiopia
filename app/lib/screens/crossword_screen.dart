import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../app/app_settings.dart';
import '../fidel_families.dart';
import '../game_progress.dart';

class CrosswordScreen extends StatefulWidget {
  const CrosswordScreen({super.key});

  @override
  State<CrosswordScreen> createState() => _CrosswordScreenState();
}

class _CrosswordScreenState extends State<CrosswordScreen> {
  int _level = 1;
  bool _levelLoaded = false;
  late List<String> _answers;
  late List<String> _keyboard;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  int _score = 0;
  bool _answersChecked = false;

  int get _familyIndex => _level - 1;

  List<String> get _family => fidelFamilies[_familyIndex];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_levelLoaded) return;

    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is int &&
        arguments >= 1 &&
        arguments <= GameProgress.totalLevels) {
      _level = arguments;
    } else {
      _level =
          GameProgress.currentLevel.clamp(1, GameProgress.totalLevels).toInt();
    }

    _loadPuzzle();
    _levelLoaded = true;
  }

  void _loadPuzzle() {
    final List<String> family = fidelFamilies[_familyIndex];
    final List<String> previousFamily = fidelFamilies[
        (_familyIndex - 1 + fidelFamilies.length) % fidelFamilies.length];

    _answers = <String>[
      family[0], family[1], family[2], '#', '#',
      '#', '#', family[3], '#', '#',
      '#', '#', family[4], family[5], family[6],
      '#', '#', '#', '#', '#',
      '#', '#', '#', '#', '#',
    ];

    _keyboard = <String>[
      ...family,
      previousFamily[0],
      previousFamily[1],
      previousFamily[2],
    ];

    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = null;
    _score = 0;
    _answersChecked = false;
  }

  int get _playableCellCount =>
      _answers.where((String letter) => letter != '#').length;

  int get _filledCellCount {
    int count = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isNotEmpty) count++;
    }
    return count;
  }

  double get _progress =>
      _playableCellCount == 0 ? 0 : _filledCellCount / _playableCellCount;

  int _playableNumberForIndex(int targetIndex) {
    int number = 0;
    for (int i = 0; i <= targetIndex; i++) {
      if (_answers[i] != '#') number++;
    }
    return number;
  }

  void _selectCell(int index) {
    if (_answers[index] == '#') return;
    setState(() {
      _selectedIndex = index;
      _answersChecked = false;
    });
  }

  void _enterLetter(String letter) {
    final int? selectedIndex = _selectedIndex;
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a white crossword square first.')),
      );
      return;
    }

    setState(() {
      _playerAnswers[selectedIndex] = letter;
      _answersChecked = false;
      _moveToNextCell();
    });
  }

  void _moveToNextCell() {
    final int? current = _selectedIndex;
    if (current == null) return;

    for (int i = current + 1; i < _answers.length; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }
    for (int i = 0; i < current; i++) {
      if (_answers[i] != '#' && _playerAnswers[i].isEmpty) {
        _selectedIndex = i;
        return;
      }
    }
  }

  void _clearSelectedCell() {
    final int? selected = _selectedIndex;
    if (selected == null) return;
    setState(() {
      _playerAnswers[selected] = '';
      _answersChecked = false;
    });
  }

  void _resetPuzzle() => setState(_loadPuzzle);

  Future<void> _checkAnswers() async {
    int correct = 0;
    bool allFilled = true;

    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] == '#') continue;
      if (_playerAnswers[i].isEmpty) allFilled = false;
      if (_playerAnswers[i] == _answers[i]) correct++;
    }

    setState(() {
      _score = correct * 10;
      _answersChecked = true;
    });

    final bool completed = allFilled && correct == _playableCellCount;
    if (!completed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$correct of $_playableCellCount letters are correct.')),
      );
      return;
    }

    await GameProgress.selectLevel(_level);
    if (AppSettings.soundEnabled.value) {
      final AudioPlayer player = AudioPlayer();
      try {
        await player.play(AssetSource('sounds/level_complete.wav'));
      } catch (_) {
        // The visual completion flow still works if audio is unavailable.
      } finally {
        await player.dispose();
      }
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.emoji_events_rounded,
            size: 58,
            color: Color(0xFFF4C430),
          ),
          title: const Text('Puzzle Complete!', textAlign: TextAlign.center),
          content: Text(
            'Excellent! You completed Level $_level and scored $_score points.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FilledButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _resetPuzzle();
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Play Again'),
            ),
            if (_nextFamilyLevel != null)
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _goToLevel(_nextFamilyLevel!);
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next Family'),
              ),
          ],
        );
      },
    );
  }

  int? get _previousFamilyLevel {
    if (_level <= 1) return null;
    return _level - 1;
  }

  int? get _nextFamilyLevel {
    if (_level >= GameProgress.totalLevels) return null;
    return _level + 1;
  }

  void _goToLevel(int newLevel) {
    if (newLevel < 1 || newLevel > GameProgress.totalLevels) {
      return;
    }
    GameProgress.selectLevel(newLevel);
    setState(() {
      _level = newLevel;
      _loadPuzzle();
    });
  }

  Color _cellBackgroundColor(int index) {
    if (_answers[index] == '#') return const Color(0xFF172033);
    if (_selectedIndex == index) return const Color(0xFFF4C430);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFFD8F3DC)
          : const Color(0xFFFFD6D6);
    }
    return Colors.white;
  }

  Color _cellBorderColor(int index) {
    if (_selectedIndex == index) return const Color(0xFF078930);
    if (_answersChecked && _playerAnswers[index].isNotEmpty) {
      return _playerAnswers[index] == _answers[index]
          ? const Color(0xFF078930)
          : const Color(0xFFDA121A);
    }
    return const Color(0xFFB8C0CC);
  }

  @override
  Widget build(BuildContext context) {
    if (!_levelLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075A32),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Fidel Crossword — Level $_level',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset puzzle',
            onPressed: _resetPuzzle,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildInformationCard(),
                  const SizedBox(height: 18),
                  _buildInstructionsCard(),
                  const SizedBox(height: 18),
                  _buildCrosswordGrid(),
                  const SizedBox(height: 20),
                  const Row(
                    children: <Widget>[
                      Icon(Icons.keyboard_rounded, color: Color(0xFF075A32)),
                      SizedBox(width: 8),
                      Text(
                        'Choose a Fidel letter',
                        style: TextStyle(
                          color: Color(0xFF172033),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildFidelKeyboard(),
                  const SizedBox(height: 18),
                  _buildActionButtons(),
                  const SizedBox(height: 16),
                  _buildFamilyNavigation(),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF075A32), Color(0xFF0B8F46)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Level $_level — ${_family.first} Family',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Learn the seven forms of ${_family.first}.',
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF4C430)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_filledCellCount / $_playableCellCount letters',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4C430), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.lightbulb_rounded, color: Color(0xFF8A6800), size: 29),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Complete the ${_family.first} family from ${_family.first} to ${_family.last}. Tap a white square and choose the correct Fidel letter below.',
              style: const TextStyle(color: Color(0xFF594300), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrosswordGrid() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _answers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            final bool isBlocked = _answers[index] == '#';
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: isBlocked ? null : () => _selectCell(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: _cellBackgroundColor(index),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _cellBorderColor(index),
                    width: _selectedIndex == index ? 3 : 1.5,
                  ),
                ),
                child: isBlocked
                    ? null
                    : Stack(
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            left: 7,
                            child: Text(
                              '${_playableNumberForIndex(index)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              _playerAnswers[index],
                              style: const TextStyle(
                                color: Color(0xFF172033),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFidelKeyboard() {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      alignment: WrapAlignment.center,
      children: _keyboard.map((String letter) {
        return SizedBox(
          width: 67,
          height: 57,
          child: FilledButton(
            onPressed: () => _enterLetter(letter),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF075A32),
              elevation: 2,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
                side: const BorderSide(color: Color(0xFFB7D8C5)),
              ),
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearSelectedCell,
                icon: const Icon(Icons.backspace_outlined),
                label: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _resetPuzzle,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _checkAnswers,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF078930),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Check Answers'),
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyNavigation() {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _previousFamilyLevel == null
                ? null
                : () => _goToLevel(_previousFamilyLevel!),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Previous Family'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _nextFamilyLevel == null
                ? null
                : () => _goToLevel(_nextFamilyLevel!),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Next Family'),
          ),
        ),
      ],
    );
  }
}
