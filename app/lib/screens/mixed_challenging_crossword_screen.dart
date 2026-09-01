import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../app/app_settings.dart';
import '../fidel_families.dart';

class MixedChallengingCrosswordScreen extends StatefulWidget {
  const MixedChallengingCrosswordScreen({super.key});

  @override
  State<MixedChallengingCrosswordScreen> createState() =>
      _MixedChallengingCrosswordScreenState();
}

class _MixedChallengingCrosswordScreenState
    extends State<MixedChallengingCrosswordScreen> {
  int _challengeIndex = 0;
  late List<String> _playerAnswers;
  int? _selectedIndex;
  int _score = 0;
  bool _answersChecked = false;

  List<String> get _family => fidelFamilies[_challengeIndex];

  List<String> get _answers => <String>[
        _family[0], _family[1], _family[2], '#', '#',
        '#', '#', _family[3], '#', '#',
        '#', '#', _family[4], _family[5], _family[6],
        '#', '#', '#', '#', '#',
        '#', '#', '#', '#', '#',
      ];

  List<String> get _keyboard {
    final List<String> family = _family;
    final List<String> next = fidelFamilies[(_challengeIndex + 1) % fidelFamilies.length];
    final List<String> mixed = <String>[
      family[4], family[0], family[6], family[2], family[5],
      family[1], family[3], next[1], next[0], next[2],
    ];
    return mixed;
  }

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    _playerAnswers = List<String>.filled(_answers.length, '');
    _selectedIndex = null;
    _score = 0;
    _answersChecked = false;
  }

  void _openChallenge(int index) {
    setState(() {
      _challengeIndex = index;
      _loadPuzzle();
    });
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

  void _previousChallenge() {
    if (_challengeIndex == 0) return;
    _openChallenge(_challengeIndex - 1);
  }

  void _nextChallenge() {
    if (_challengeIndex >= fidelFamilies.length - 1) return;
    _openChallenge(_challengeIndex + 1);
  }

  Future<void> _showChallenges() async {
    final int? selected = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Challenges', textAlign: TextAlign.center),
          content: SizedBox(
            width: 520,
            height: 420,
            child: GridView.builder(
              itemCount: fidelFamilies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.35,
              ),
              itemBuilder: (BuildContext context, int index) {
                return OutlinedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(index),
                  child: Text(
                    '${index + 1}\n${fidelFamilies[index].first}',
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
    if (selected != null && mounted) _openChallenge(selected);
  }

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

    if (AppSettings.soundEnabled.value) {
      final AudioPlayer player = AudioPlayer();
      try {
        await player.play(AssetSource('sounds/level_complete.wav'));
      } catch (_) {
        // Keep visual completion working if celebration audio is unavailable.
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
          icon: const Icon(Icons.emoji_events_rounded, size: 58, color: Color(0xFFF4C430)),
          title: const Text('Challenge Complete!', textAlign: TextAlign.center),
          content: Text(
            'Excellent! You solved the ${_family.first} family challenge and scored $_score points.',
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
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showChallenges();
              },
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text('Challenges'),
            ),
          ],
        );
      },
    );
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF172033),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Fidel Crossword — Mixed Challenge', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            tooltip: 'Challenges',
            onPressed: _showChallenges,
            icon: const Icon(Icons.grid_view_rounded),
          ),
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
                        'Choose from the mixed Fidel letters',
                        style: TextStyle(color: Color(0xFF172033), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildFidelKeyboard(),
                  const SizedBox(height: 18),
                  _buildActionButtons(),
                  const SizedBox(height: 12),
                  _buildChallengeNavigation(),
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
        gradient: const LinearGradient(colors: <Color>[Color(0xFF075A32), Color(0xFF0B8F46)]),
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
                      'Challenge ${_challengeIndex + 1} — ${_family.first} Family',
                      style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Arrange all seven forms of ${_family.first}.',
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
                    const Text('SCORE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('$_score', style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
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
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
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
              'Tap a white square, then choose from the mixed Fidel letters below. Arrange ${_family.join(', ')} in the correct 1–7 order.',
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
                  border: Border.all(color: _cellBorderColor(index), width: _selectedIndex == index ? 3 : 1.5),
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
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              _playerAnswers[index],
                              style: const TextStyle(color: Color(0xFF172033), fontSize: 30, fontWeight: FontWeight.bold),
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
              foregroundColor: const Color(0xFF9D0B11),
              elevation: 2,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
                side: const BorderSide(color: Color(0xFFE3B7B9)),
              ),
            ),
            child: Text(letter, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
              backgroundColor: const Color(0xFF9D0B11),
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

  Widget _buildChallengeNavigation() {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _challengeIndex > 0 ? _previousChallenge : null,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Previous Family'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showChallenges,
            icon: const Icon(Icons.grid_view_rounded),
            label: const Text('Challenges'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _challengeIndex < fidelFamilies.length - 1 ? _nextChallenge : null,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Next Family'),
          ),
        ),
      ],
    );
  }
}
