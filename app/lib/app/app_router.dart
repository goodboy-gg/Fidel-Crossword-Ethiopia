import 'package:flutter/material.dart';

import '../screens/coming_soon_screen.dart';

import '../screens/home_screen.dart';

import '../screens/levels_screen.dart';

import '../screens/splash_screen.dart';
import '../screens/crossword_screen.dart';
import 'app_routes.dart';



  class AppRouter {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    switch (settings.name) {

      case AppRoutes.splash:

        return MaterialPageRoute(

          builder: (_) => const SplashScreen(),

          settings: settings,

        );

      case AppRoutes.home:

        return MaterialPageRoute(

          builder: (_) => const HomeScreen(),

          settings: settings,

        );

      case AppRoutes.levels:

        return MaterialPageRoute(

          builder: (_) => const LevelsScreen(),

          settings: settings,

        );

      case AppRoutes.crossword:

        return MaterialPageRoute(

          builder: (_) => const CrosswordScreen(),

            

          settings: settings,

        );

      case AppRoutes.placeholder:

        return MaterialPageRoute(

          builder: (_) => const PlaceholderScreen(

            title: 'Coming Soon',

            message: 'This feature is being prepared.',

            icon: Icons.construction_rounded,

          ),

          settings: settings,

        );

      default:

        return MaterialPageRoute(

          builder: (_) => const SplashScreen(),

          settings: settings,

        );

    }

  }

}


class LearnFidelScreen extends StatefulWidget {
  const LearnFidelScreen({super.key});

  @override
  State<LearnFidelScreen> createState() => _LearnFidelScreenState();
}

class _LearnFidelScreenState extends State<LearnFidelScreen> {
  FidelFamily? selectedFamily;

  static const List<FidelFamily> fidelFamilies = [
    FidelFamily(
      name: 'ሀ Family',
      letters: ['ሀ', 'ሁ', 'ሂ', 'ሃ', 'ሄ', 'ህ', 'ሆ'],
    ),
    FidelFamily(
      name: 'ለ Family',
      letters: ['ለ', 'ሉ', 'ሊ', 'ላ', 'ሌ', 'ል', 'ሎ'],
    ),
    FidelFamily(
      name: 'ሐ Family',
      letters: ['ሐ', 'ሑ', 'ሒ', 'ሓ', 'ሔ', 'ሕ', 'ሖ'],
    ),
    FidelFamily(
      name: 'መ Family',
      letters: ['መ', 'ሙ', 'ሚ', 'ማ', 'ሜ', 'ም', 'ሞ'],
    ),
    FidelFamily(
      name: 'ሠ Family',
      letters: ['ሠ', 'ሡ', 'ሢ', 'ሣ', 'ሤ', 'ሥ', 'ሦ'],
    ),
    FidelFamily(
      name: 'ረ Family',
      letters: ['ረ', 'ሩ', 'ሪ', 'ራ', 'ሬ', 'ር', 'ሮ'],
    ),
    FidelFamily(
      name: 'ሰ Family',
      letters: ['ሰ', 'ሱ', 'ሲ', 'ሳ', 'ሴ', 'ስ', 'ሶ'],
    ),
    FidelFamily(
      name: 'ሸ Family',
      letters: ['ሸ', 'ሹ', 'ሺ', 'ሻ', 'ሼ', 'ሽ', 'ሾ'],
    ),
    FidelFamily(
      name: 'ቀ Family',
      letters: ['ቀ', 'ቁ', 'ቂ', 'ቃ', 'ቄ', 'ቅ', 'ቆ'],
    ),
    FidelFamily(
      name: 'በ Family',
      letters: ['በ', 'ቡ', 'ቢ', 'ባ', 'ቤ', 'ብ', 'ቦ'],
    ),
    FidelFamily(
      name: 'ተ Family',
      letters: ['ተ', 'ቱ', 'ቲ', 'ታ', 'ቴ', 'ት', 'ቶ'],
    ),
    FidelFamily(
      name: 'ቸ Family',
      letters: ['ቸ', 'ቹ', 'ቺ', 'ቻ', 'ቼ', 'ች', 'ቾ'],
    ),
    FidelFamily(
      name: 'ኀ Family',
      letters: ['ኀ', 'ኁ', 'ኂ', 'ኃ', 'ኄ', 'ኅ', 'ኆ'],
    ),
    FidelFamily(
      name: 'ነ Family',
      letters: ['ነ', 'ኑ', 'ኒ', 'ና', 'ኔ', 'ን', 'ኖ'],
    ),
    FidelFamily(
      name: 'ኘ Family',
      letters: ['ኘ', 'ኙ', 'ኚ', 'ኛ', 'ኜ', 'ኝ', 'ኞ'],
    ),
    FidelFamily(
      name: 'አ Family',
      letters: ['አ', 'ኡ', 'ኢ', 'ኣ', 'ኤ', 'እ', 'ኦ'],
    ),
    FidelFamily(
      name: 'ከ Family',
      letters: ['ከ', 'ኩ', 'ኪ', 'ካ', 'ኬ', 'ክ', 'ኮ'],
    ),
    FidelFamily(
      name: 'ኸ Family',
      letters: ['ኸ', 'ኹ', 'ኺ', 'ኻ', 'ኼ', 'ኽ', 'ኾ'],
    ),
    FidelFamily(
      name: 'ወ Family',
      letters: ['ወ', 'ዉ', 'ዊ', 'ዋ', 'ዌ', 'ው', 'ዎ'],
    ),
    FidelFamily(
      name: 'ዐ Family',
      letters: ['ዐ', 'ዑ', 'ዒ', 'ዓ', 'ዔ', 'ዕ', 'ዖ'],
    ),
    FidelFamily(
      name: 'ዘ Family',
      letters: ['ዘ', 'ዙ', 'ዚ', 'ዛ', 'ዜ', 'ዝ', 'ዞ'],
    ),
    FidelFamily(
      name: 'ዠ Family',
      letters: ['ዠ', 'ዡ', 'ዢ', 'ዣ', 'ዤ', 'ዥ', 'ዦ'],
    ),
    FidelFamily(
      name: 'የ Family',
      letters: ['የ', 'ዩ', 'ዪ', 'ያ', 'ዬ', 'ይ', 'ዮ'],
    ),
    FidelFamily(
      name: 'ደ Family',
      letters: ['ደ', 'ዱ', 'ዲ', 'ዳ', 'ዴ', 'ድ', 'ዶ'],
    ),
    FidelFamily(
      name: 'ጀ Family',
      letters: ['ጀ', 'ጁ', 'ጂ', 'ጃ', 'ጄ', 'ጅ', 'ጆ'],
    ),
    FidelFamily(
      name: 'ገ Family',
      letters: ['ገ', 'ጉ', 'ጊ', 'ጋ', 'ጌ', 'ግ', 'ጎ'],
    ),
    FidelFamily(
      name: 'ጠ Family',
      letters: ['ጠ', 'ጡ', 'ጢ', 'ጣ', 'ጤ', 'ጥ', 'ጦ'],
    ),
    FidelFamily(
      name: 'ጨ Family',
      letters: ['ጨ', 'ጩ', 'ጪ', 'ጫ', 'ጬ', 'ጭ', 'ጮ'],
    ),
    FidelFamily(
      name: 'ጰ Family',
      letters: ['ጰ', 'ጱ', 'ጲ', 'ጳ', 'ጴ', 'ጵ', 'ጶ'],
    ),
    FidelFamily(
      name: 'ጸ Family',
      letters: ['ጸ', 'ጹ', 'ጺ', 'ጻ', 'ጼ', 'ጽ', 'ጾ'],
    ),
    FidelFamily(
      name: 'ፀ Family',
      letters: ['ፀ', 'ፁ', 'ፂ', 'ፃ', 'ፄ', 'ፅ', 'ፆ'],
    ),
    FidelFamily(
      name: 'ፈ Family',
      letters: ['ፈ', 'ፉ', 'ፊ', 'ፋ', 'ፌ', 'ፍ', 'ፎ'],
    ),
    FidelFamily(
      name: 'ፐ Family',
      letters: ['ፐ', 'ፑ', 'ፒ', 'ፓ', 'ፔ', 'ፕ', 'ፖ'],
    ),
    FidelFamily(
      name: 'ቨ Family',
      letters: ['ቨ', 'ቩ', 'ቪ', 'ቫ', 'ቬ', 'ቭ', 'ቮ'],
    ),
  ];

  void _selectFamily(FidelFamily family) {
    setState(() {
      selectedFamily = family;
    });
  }

  void _showComingFeature(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be connected in the next stage.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLetter(FidelFamily family, String letter, int order) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  family.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 82,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Order $order of 7',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showComingFeature('Pronunciation');
                    },
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Listen'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showComingFeature('Writing practice');
                    },
                    icon: const Icon(Icons.draw_rounded),
                    label: const Text('Practice Writing'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FidelFamily? family = selectedFamily;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          family == null ? 'Learn Fidel' : family.name,
        ),
        leading: family == null
            ? null
            : IconButton(
                tooltip: 'All families',
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  setState(() {
                    selectedFamily = null;
                  });
                },
              ),
      ),
      body: family == null
          ? _buildFamilySelection()
          : _buildFamilyLesson(family),
    );
  }

  Widget _buildFamilySelection() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a Fidel Family',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Study every family in the correct order. '
                    'Tap a family to see its seven letters.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.school_rounded),
                      const SizedBox(width: 8),
                      Text(
                        '${fidelFamilies.length} Fidel families',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            sliver: SliverGrid.builder(
              itemCount: fidelFamilies.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                final FidelFamily family = fidelFamilies[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _selectFamily(family),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            family.firstLetter,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            family.name,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyLesson(FidelFamily family) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  family.firstLetter,
                  style: const TextStyle(
                    fontSize: 78,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  family.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tap each letter to study it.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Seven Orders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: family.letters.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final String letter = family.letters[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _showLetter(
                    family,
                    letter,
                    index + 1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Order ${index + 1}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Learning Activities',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _showComingFeature('Pronunciation'),
            icon: const Icon(Icons.volume_up_rounded),
            label: const Text('Listen to Pronunciation'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _showComingFeature('Writing practice'),
            icon: const Icon(Icons.draw_rounded),
            label: const Text('Practice Writing'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _showComingFeature('Matching crossword'),
            icon: const Icon(Icons.grid_view_rounded),
            label: const Text('Play This Family'),
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () {
              setState(() {
                selectedFamily = null;
              });
            },
            icon: const Icon(Icons.apps_rounded),
            label: const Text('Choose Another Family'),
          ),
        ],
      ),
    );
  }
}

class FidelFamily {
  const FidelFamily({
    required this.name,
    required this.letters,
  });

  final String name;
  final List<String> letters;

  String get firstLetter => letters.first;
}


