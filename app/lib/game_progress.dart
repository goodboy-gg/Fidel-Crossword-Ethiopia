import 'package:shared_preferences/shared_preferences.dart';

class GameProgress {

  GameProgress._();

  static const int totalLevels = 12;

  static const String _highestUnlockedKey =

      'highest_unlocked_level';

  static const String _currentLevelKey =

      'current_level';

  static int currentLevel = 1;

  static int highestUnlockedLevel = 12;

  static bool _hasLoaded = false;

  static bool get hasLoaded => _hasLoaded;

  static Future<void> loadProgress() async {

    final SharedPreferences preferences =

        await SharedPreferences.getInstance();

    currentLevel =

        preferences.getInt(_currentLevelKey) ?? 1;

    highestUnlockedLevel =

        preferences.getInt(_highestUnlockedKey) ?? 12;

    if (currentLevel < 1 ||

        currentLevel > totalLevels) {

      currentLevel = 1;

    }

    if (highestUnlockedLevel < 1) {

      highestUnlockedLevel = 1;

    }

    if (highestUnlockedLevel > totalLevels) {

      highestUnlockedLevel = totalLevels;

    }

    if (currentLevel > highestUnlockedLevel) {

      currentLevel = highestUnlockedLevel;

    }

    _hasLoaded = true;

  }

  static bool isLevelUnlocked(int level) {

    return level >= 1 &&

        level <= highestUnlockedLevel;

  }

  static Future<void> selectLevel(int level) async {

    if (!isLevelUnlocked(level)) {

      return;

    }

    currentLevel = level;

    final SharedPreferences preferences =

        await SharedPreferences.getInstance();

    await preferences.setInt(

      _currentLevelKey,

      currentLevel,

    );

  }

  static Future<void> unlockNextLevel(

    int completedLevel,

  ) async {

    final int nextLevel = completedLevel + 1;

    if (nextLevel > highestUnlockedLevel &&

        nextLevel <= totalLevels;

     Future<void> unlockAllLevels() async {


  highestUnlockedLevel = totalLevels;

  final SharedPreferences preferences =

      await SharedPreferences.getInstance();

  await preferences.setInt(

    _highestUnlockedKey,

    highestUnlockedLevel,

  );

}


    

          await SharedPreferences.getInstance();

      await preferences.setInt(

        _highestUnlockedKey,

        highestUnlockedLevel,

      );

    }

  }

  static Future<void> resetProgress() async {

    currentLevel = 1;

    highestUnlockedLevel = 1;

    final SharedPreferences preferences =

        await SharedPreferences.getInstance();

    await preferences.setInt(

      _currentLevelKey,

      currentLevel,

    );

    await preferences.setInt(

      _highestUnlockedKey,

      highestUnlockedLevel,

    );

  }
static Future<void> unlockAllLevels() async {

  highestUnlockedLevel = totalLevels;

  final SharedPreferences preferences =

      await SharedPreferences.getInstance();

  await preferences.setInt(

    _highestUnlockedKey,

    highestUnlockedLevel,

  );
static Future<void> unlockAllLevels() async {

  highestUnlockedLevel = totalLevels;

  final SharedPreferences preferences =

      await SharedPreferences.getInstance();

  await preferences.setInt(

    _highestUnlockedKey,

    highestUnlockedLevel,

  );

}
}
static Future<void> resetProgress() async {



  currentLevel = 1;



  highestUnlockedLevel = 1;



  final SharedPreferences preferences =



      await SharedPreferences.getInstance();



  await preferences.setInt(



    _currentLevelKey,



    currentLevel,



  );



  await preferences.setInt(



    _highestUnlockedKey,



    highestUnlockedLevel,



  );



}
}

