import 'package:flutter/material.dart';

void main() {

  runApp(const FidelApp());

}

class FidelApp extends StatelessWidget {

  const FidelApp({super.key});

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Fidel Crossword Ethiopia',

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(

          seedColor: Colors.green,

        ),

      ),

      home: const HomePage(),

    );

  }

}

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Fidel Crossword Ethiopia'),

      ),
body: Center(

  child: Column(

    mainAxisAlignment: MainAxisAlignment.center,

    children: [

      ElevatedButton(

        onPressed: () {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (context) => const CrosswordPage(),

    ),

  );

},

        child: const Text('Play Crossword'),

      ),

      const SizedBox(height: 20),

      ElevatedButton(

        onPressed: () {},

        child: const Text('Learn Fidel'),

      ),

      const SizedBox(height: 20),

      ElevatedButton(

        onPressed: () {},

        child: const Text('Settings'),

      ),

    ],

  ),

),
      

    );

  }
}
class CrosswordPage extends StatefulWidget {

  const CrosswordPage({super.key});

  @override

  State<CrosswordPage> createState() => _CrosswordPageState();

}

class _CrosswordPageState extends State<CrosswordPage> {

  int score = 0;

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Fidel Crossword'),

      ),

      body: Center(

  child: Column(

    mainAxisAlignment: MainAxisAlignment.center,

  
children: [

  Text(

    'Score: $score',

    style: const TextStyle(

      fontSize: 22,

      fontWeight: FontWeight.bold,

    ),

  ),

  const SizedBox(height: 20),

  

      const Text(

        'Level 1',

        style: TextStyle(

          fontSize: 28,

          fontWeight: FontWeight.bold,

        ),

      ),

      const SizedBox(height: 30),
      const Text(

  'Clue: The first letter of the Amharic alphabet',

  style: TextStyle(

    fontSize: 18,

    fontWeight: FontWeight.bold,

  ),

),

const SizedBox(height: 20),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [



    GestureDetector(



      onTap: () {
        setState(() {
          score = 10;
        });


        ScaffoldMessenger.of(context).showSnackBar(



          const SnackBar(



            content: Text('You tapped ሀ'),



          ),



        );



      },



      child: _buildCell('ሀ'),



    ),



    GestureDetector(



      onTap: () {



        ScaffoldMessenger.of(context).showSnackBar(



          const SnackBar(



            content: Text('You tapped ሁ'),



          ),



        );



      },



      child: _buildCell('ሁ'),



    ),



    GestureDetector(



      onTap: () {



        ScaffoldMessenger.of(context).showSnackBar(



          const SnackBar(



            content: Text('You tapped ሂ'),



          ),



        );



      },



      child: _buildCell('ሂ'),



    ),



    GestureDetector(



      onTap: () {



        ScaffoldMessenger.of(context).showSnackBar(



          const SnackBar(



            content: Text('You tapped ሃ'),



          ),



        );



      },



      child: _buildCell('ሃ'),



    ),



  ],



),




      const SizedBox(height: 30),

      const Text(

        'Our first Fidel crossword row',

        style: TextStyle(fontSize: 20),

      ),

    ],

  ),

),



    );

  } 
Widget _buildCell(String letter) {

  return Container(

    width: 70,

    height: 70,

    margin: const EdgeInsets.all(4),

    alignment: Alignment.center,

    decoration: BoxDecoration(

  color: Colors.green,
  

  border: Border.all(width: 2),

  borderRadius: BorderRadius.circular(8),

),
      

    child: Text(

      letter,

      style: const TextStyle(

        fontSize: 30,

        fontWeight: FontWeight.bold,

      ),

    ),

  );

}

  }

