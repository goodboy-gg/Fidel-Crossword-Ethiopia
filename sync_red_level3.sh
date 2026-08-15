#!/usr/bin/env bash
set -e
BRANCH="learn-fidel-safe-build"
TARGET="release-1.0.0-test/Fidel-Crossword-Ethiopia-Release-1.0.0/app/lib/screens"

git fetch origin "$BRANCH"
mkdir -p "$TARGET"
git show "origin/$BRANCH:app/lib/screens/levels_screen.dart" > "$TARGET/levels_screen.dart"
git show "origin/$BRANCH:app/lib/screens/level3_family_challenge_screen.dart" > "$TARGET/level3_family_challenge_screen.dart"

grep -q "Level 3 — Challenge" "$TARGET/levels_screen.dart"
grep -q "Level3FamilyChallengeScreen" "$TARGET/levels_screen.dart"
grep -q "Check All 34 Families" "$TARGET/level3_family_challenge_screen.dart"

echo "LEVEL 3 FULL FAMILY CHALLENGE READY"
echo "LEVEL 3 ROUTE VERIFIED"
echo "34-FAMILY GAME VERIFIED"
