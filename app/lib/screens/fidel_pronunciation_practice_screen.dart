import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../app/app_settings.dart';
import '../fidel_families.dart';

class FidelPronunciationPracticeScreen extends StatefulWidget {
  const FidelPronunciationPracticeScreen({super.key});

  @override
  State<FidelPronunciationPracticeScreen> createState() =>
      _FidelPronunciationPracticeScreenState();
}

class _LetterPronunciation {
  const _LetterPronunciation({
    required this.familyNumber,
    required this.order,
    required this.letter,
    required this.english,
  });

  final int familyNumber;
  final int order;
  final String letter;
  final String english;
}

class _FidelPronunciationPracticeScreenState
    extends State<FidelPronunciationPracticeScreen> {
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
  late final List<_LetterPronunciation> _letters;

  @override
  void initState() {
    super.initState();
    _letters = _buildLetters();
  }

  List<_LetterPronunciation> _buildLetters() {
    final List<_LetterPronunciation> entries = <_LetterPronunciation>[];

    for (
      int familyIndex = 0;
      familyIndex < fidelFamilies.length;
      familyIndex++
    ) {
      final List<String> family = fidelFamilies[familyIndex];
      for (int orderIndex = 0; orderIndex < family.length; orderIndex++) {
        entries.add(
          _LetterPronunciation(
            familyNumber: familyIndex + 1,
            order: orderIndex + 1,
            letter: family[orderIndex],
            english: _englishPronunciations[familyIndex][orderIndex],
          ),
        );
      }
    }

    return entries;
  }

  String _audioFileForLetter(String letter) {
    final int code = letter.runes.first;
    final String unicode = code.toRadixString(16).toLowerCase();

    final bool usesWavFix =
        (code >= 0x1238 && code <= 0x123e) ||
        (code >= 0x12f0 && code <= 0x12f6) ||
        (code >= 0x1300 && code <= 0x1306) ||
        (code >= 0x1338 && code <= 0x133e);

    return 'sounds/fidel_$unicode.${usesWavFix ? 'wav' : 'm4a'}';
  }

  Future<void> _playLetter(String letter) async {
    if (!AppSettings.soundEnabled.value) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Sound is turned off in Settings.')),
        );
      return;
    }

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(_audioFileForLetter(letter)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('The sound for $letter could not be played.'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEFF),
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
              constraints: const BoxConstraints(maxWidth: 980),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E5FF),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFCFB8ED)),
                    ),
                    child: const Text(
                      'Tap each Fidel letter to hear the original pronunciation recording. The family order stays exactly 1–7 across all 33 families.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E1A47),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final int crossAxisCount = constraints.maxWidth >= 900
                              ? 7
                              : constraints.maxWidth >= 620
                              ? 5
                              : 3;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _letters.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.9,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              final _LetterPronunciation item = _letters[index];

                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => _playLetter(item.letter),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFFE0D3F7),
                                    ),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color(0x1A6A1B9A),
                                        blurRadius: 10,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'F${item.familyNumber}.${item.order}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6A1B9A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.letter,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E1E1E),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.english,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4A3D5A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
