#!/usr/bin/env bash
set -e
TARGET="release-1.0.0-test/Fidel-Crossword-Ethiopia-Release-1.0.0/app/lib/screens"
cp app/lib/screens/levels_screen.dart "$TARGET/levels_screen.dart"
cp app/lib/screens/challenge_crossword_screen.dart "$TARGET/challenge_crossword_screen.dart"
echo "RED LEVEL 3 READY"
