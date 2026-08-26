import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../fidel_families.dart';

class FidelPronunciationPracticeScreen extends StatefulWidget {
  const FidelPronunciationPracticeScreen({super.key});

  @override
  State<FidelPronunciationPracticeScreen> createState() =>
      _FidelPronunciationPracticeScreenState();
}

class _FidelPronunciationPracticeScreenState
    extends State<FidelPronunciationPracticeScreen> {
  // Plain-English sound hints. The saved audio recording is the authority
  // for the exact pronunciation; these labels are an easy reading guide.
  static const List<List<String>> _englishPronunciations = <List<String>>[
    <String>['Huh', 'Hoo', 'Hee', 'Hah', 'Heh', 'Hih', 'Hoh'],
    <String>['Luh', 'Loo', 'Lee', 'Lah', 'Leh', 'Lih', 'Loh'],
    <String>['Huh', 'Hoo', 'Hee', 'Hah', 'Heh', 'Hih', 'Hoh'],
    <String>['Muh', 'Moo', 'Mee', 'Mah', 'Meh', 'Mih', 'Moh'],
    <String>['Suh', 'Soo', 'See', 'Sah', 'Seh', 'Sih', 'Soh'],
    <String>['Ruh', 'Roo', 'Ree', 'Rah', 'Reh', 'Rih', 'Roh'],
    <String>['Suh', 'Soo', 'See', 'Sah', 'Seh', 'Sih', 'Soh'],
    <String>['Shuh', 'Shoo', 'Shee', 'Shah', 'Sheh', 'Shih', 'Shoh'],
    <String>['Quh', 'Qoo', 'Qee', 'Qah', 'Qeh', 'Qih', 'Qoh'],
    <String>['Buh', 'Boo', 'Bee', 'Bah', 'Beh', 'Bih', 'Boh'],
    <String>['Tuh', 'Too', 'Tee', 'Tah', 'Teh', 'Tih', 'Toh'],
    <String>['Chuh', 'Choo', 'Chee', 'Chah', 'Cheh', 'Chih', 'Choh'],
    <String>['Huh', 'Hoo', 'Hee', 'Hah', 'Heh', 'Hih', 'Hoh'],
    <String>['Nuh', 'Noo', 'Nee', 'Nah', 'Neh', 'Nih', 'Noh'],
    <String>['Nyuh', 'Nyoo', 'Nyee', 'Nyah', 'Nyeh', 'Nyih', 'Nyoh'],
    <String>['Uh', 'Oo', 'Ee', 'Ah', 'Eh', 'Ih', 'Oh'],
    <String>['Kuh', 'Koo', 'Kee', 'Kah', 'Keh', 'Kih', 'Koh'],
    <String>['Khuh', 'Khoo', 'Khee', 'Khah', 'Kheh', 'Khih', 'Khoh'],
    <String>['Wuh', 'Woo', 'Wee', 'Wah', 'Weh', 'Wih', 'Woh'],
    <String>['Uh', 'Oo', 'Ee', 'Ah', 'Eh', 'Ih', 'Oh'],
    <String>['Zuh', 'Zoo', 'Zee', 'Zah', 'Zeh', 'Zih', 'Zoh'],
    <String>['Zhuh', 'Zhoo', 'Zhee', 'Zhah', 'Zheh', 'Zhih', 'Zhoh'],
    <String>['Yuh', 'Yoo', 'Yee', 'Yah', 'Yeh', 'Yih', 'Yoh'],
    <String>['Duh', 'Doo', 'Dee', 'Dah', 'Deh', 'Dih', 'Doh'],
    <String>['Juh', 'Joo', 'Jee', 'Jah', 'Jeh', 'Jih', 'Joh'],
    <String>['Guh', 'Goo', 'Gee', 'Gah', 'Geh', 'Gih', 'Goh'],
    <String>['Tuh', 'Too', 'Tee', 'Tah', 'Teh', 'Tih', 'Toh'],
    <String>['Chuh', 'Choo', 'Chee', 'Chah', 'Cheh', 'Chih', 'Choh'],
    <String>['Puh', 'Poo', 'Pee', 'Pah', 'Peh', 'Pih', 'Poh'],
    <String>['Tsuh', 'Tsoo', 'Tsee', 'Tsah', 'Tseh', 'Tsih', 'Tsoh'],
    <String>['Tsuh', 'Tsoo', 'Tsee', 'Tsah', 'Tseh', 'Tsih', 'Tsoh'],
    <String>['Fuh', 'Foo', 'Fee', 'Fah', 'Feh', 'Fih', 'Foh'],
    <String>['Puh', 'Poo', 'Pee', 'Pah', 'Peh', 'Pih', 'Poh'],
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<String> _placedLetters;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _placedLetters = List<String>.filled(totalFidelFamilies * 7, '');
  }

  String _audioFileForLetter(String letter) {
    final int code = letter.runes.first;
    final String hex = code.toRadixString(16).toLowerCase();
    final bool usesWavFix =
        (code >= 0x1238 && code <= 0x123e) ||
        (code >= 0x12f0 && code <= 0x12f6) ||
        (code >= 0x1300 && code <= 0x1306) ||
        (code >= 0x1338 && code <= 0x133e);
    return 'sounds/fidel_$hex.${usesWavFix ? 'wav' : 'm4a'}';
  }

  Future<void> _playLetter(String letter) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(_audioFileForLetter(letter)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio is not available for this letter.')),
      );
    }
  }

  String _englishLabel(int familyIndex, int orderIndex) {
    return _englishPronunciations[familyIndex][orderIndex];
  }

  Future<void> _placeLetter(int familyIndex, int orderIndex) async {
    final int expectedIndex = familyIndex * 7 + orderIndex;
    final String letter = fidelFamilies[familyIndex][orderIndex];

    setState(() {
      _placedLetters[expectedIndex] = letter;
    });
    await _playLetter(letter);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int completed =
        _placedLetters.where((String letter) => letter.isNotEmpty).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '231 Fidel Pronunciation Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E5F7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFC5A3D9)),
                    ),
                    child: const Text(
                      'Read the English sound guide, then tap the matching Fidel '
                      'letter. Your original recording plays immediately after '
                      'placement, so you can hear the exact pronunciation. Every '
                      'family stays in learning order.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '$completed of ${totalFidelFamilies * 7} placed',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => setState(_reset),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...List<Widget>.generate(
                    fidelFamilies.length,
                    (int familyIndex) => _FamilyPracticeCard(
                      familyNumber: familyIndex + 1,
                      letters: fidelFamilies[familyIndex],
                      labels: List<String>.generate(
                        7,
                        (int orderIndex) =>
                            _englishLabel(familyIndex, orderIndex),
                      ),
                      placedLetters: _placedLetters.sublist(
                        familyIndex * 7,
                        familyIndex * 7 + 7,
                      ),
                      onPlaceLetter: (int orderIndex) =>
                          _placeLetter(familyIndex, orderIndex),
                      onPlayLetter: (int orderIndex) =>
                          _playLetter(fidelFamilies[familyIndex][orderIndex]),
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

class _FamilyPracticeCard extends StatelessWidget {
  const _FamilyPracticeCard({
    required this.familyNumber,
    required this.letters,
    required this.labels,
    required this.placedLetters,
    required this.onPlaceLetter,
    required this.onPlayLetter,
  });

  final int familyNumber;
  final List<String> letters;
  final List<String> labels;
  final List<String> placedLetters;
  final ValueChanged<int> onPlaceLetter;
  final ValueChanged<int> onPlayLetter;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0D4E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Family $familyNumber — ${letters.first}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 9),
          Row(
            children: List<Widget>.generate(7, (int index) {
              final bool complete = placedLetters[index].isNotEmpty;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    height: 76,
                    decoration: BoxDecoration(
                      color: complete
                          ? const Color(0xFFD8F3DC)
                          : const Color(0xFFF9F7FB),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: const Color(0xFFC8BDD0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          placedLetters[index],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF075A32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: List<Widget>.generate(7, (int index) {
              final bool used = placedLetters[index].isNotEmpty;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: SizedBox(
                    height: 49,
                    child: FilledButton(
                      onPressed: used ? () => onPlayLetter(index) : () => onPlaceLetter(index),
                      style: FilledButton.styleFrom(
                        backgroundColor: used
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFF6A1B9A),
                        foregroundColor:
                            used ? const Color(0xFF075A32) : Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: used
                          ? const Icon(Icons.volume_up_rounded, size: 20)
                          : Text(
                              letters[index],
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
