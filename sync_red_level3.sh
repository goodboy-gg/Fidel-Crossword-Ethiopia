#!/usr/bin/env bash
set -e
BRANCH="learn-fidel-safe-build"
TARGET="release-1.0.0-test/Fidel-Crossword-Ethiopia-Release-1.0.0/app/lib/screens"

git fetch origin "$BRANCH"
mkdir -p "$TARGET"

git show "origin/$BRANCH:app/lib/screens/home_screen.dart" > "$TARGET/home_screen.dart"
git show "origin/$BRANCH:app/lib/screens/levels_screen.dart" > "$TARGET/levels_screen.dart"
git show "origin/$BRANCH:app/lib/screens/level3_red_challenge_screen.dart" > "$TARGET/level3_red_challenge_screen.dart"

grep -q "title: 'Levels'" "$TARGET/home_screen.dart"
grep -q "title: 'Level 3 — Challenge'" "$TARGET/home_screen.dart"
grep -q "Level3RedChallengeScreen" "$TARGET/home_screen.dart"
grep -q "Level \$level — \${fidelFamilyName(level)}" "$TARGET/levels_screen.dart"
! grep -q "Level3RedChallengeScreen" "$TARGET/levels_screen.dart"
grep -q "Level 3 — Mixed Fidel Challenge" "$TARGET/level3_red_challenge_screen.dart"
grep -q "Previous Family" "$TARGET/level3_red_challenge_screen.dart"
grep -q "Next Family" "$TARGET/level3_red_challenge_screen.dart"

echo "NORMAL FAMILY LEVELS PRESERVED"
echo "SEPARATE LEVEL 3 CHALLENGE READY"
echo "SAVED RED 33-FAMILY CHALLENGE VERIFIED"
