#!/usr/bin/env bash
set -e
TARGET="release-1.0.0-test/Fidel-Crossword-Ethiopia-Release-1.0.0/app/lib/screens"
mkdir -p "$TARGET"
git show origin/learn-fidel-safe-build:app/lib/screens/levels_screen.dart > "$TARGET/levels_screen.dart"
git show origin/learn-fidel-safe-build:app/lib/screens/challenge_crossword_screen.dart > "$TARGET/challenge_crossword_screen.dart"
echo "RED LEVEL 3 READY"
