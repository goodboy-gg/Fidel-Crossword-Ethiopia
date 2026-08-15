#!/usr/bin/env bash
set -e
BRANCH="learn-fidel-safe-build"
TARGET="release-1.0.0-test/Fidel-Crossword-Ethiopia-Release-1.0.0/app/lib/screens"

git fetch origin "$BRANCH"
mkdir -p "$TARGET"
git show "origin/$BRANCH:app/lib/screens/levels_screen.dart" > "$TARGET/levels_screen.dart"
git show "origin/$BRANCH:app/lib/screens/challenge_crossword_screen.dart" > "$TARGET/challenge_crossword_screen.dart"

grep -q "Level 3 — Challenge" "$TARGET/levels_screen.dart"
grep -q "ChallengeCrosswordScreen(level: 3)" "$TARGET/levels_screen.dart"

echo "RED LEVEL 3 READY"
echo "LEVEL 3 ROUTE VERIFIED"
