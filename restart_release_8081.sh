#!/usr/bin/env bash
set -e
ROOT="/workspaces/Fidel-Crossword-Ethiopia"
APP="$ROOT/release-1.0.0-test/Fidel-Crossword-Ethiopia-Release-1.0.0/app"

cd "$ROOT"
bash sync_red_level3.sh

pkill -f "flutter.*run.*web-server.*8081" 2>/dev/null || true
sleep 1

cd "$APP"
echo "STARTING CORRECT RELEASE APP ON 8081"
exec "$ROOT/flutter/bin/flutter" run -d web-server --web-hostname 0.0.0.0 --web-port 8081
