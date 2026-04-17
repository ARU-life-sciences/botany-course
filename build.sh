#!/usr/bin/env bash
# Build all botany course lectures to PDF.
# Output PDFs sit alongside their source in ./lectures/.
# Usage: ./build.sh [--watch]

set -euo pipefail

COURSE_ROOT="$(cd "$(dirname "$0")" && pwd)"
LECTURES_DIR="$COURSE_ROOT/lectures"
WATCH=${1:-}

ok=0; fail=0

compile_one() {
  local src="$1"
  local name
  name="$(basename "$src" .typ)"
  local out="$LECTURES_DIR/${name}.pdf"

  printf "  %-30s → %s ... " "$name.typ" "${name}.pdf"
  if typst compile --root "$COURSE_ROOT" "$src" "$out" 2>&1; then
    echo "OK"
    ((ok++)) || true
  else
    echo "FAILED"
    ((fail++)) || true
  fi
}

if [[ "$WATCH" == "--watch" ]]; then
  # Watch mode: recompile whichever file changes (run one watcher per file)
  echo "Watching lectures/ for changes (Ctrl-C to stop)…"
  for src in "$LECTURES_DIR"/main_*.typ; do
    name="$(basename "$src" .typ)"
    typst watch "$src" "$LECTURES_DIR/${name}.pdf" &
  done
  wait
else
  echo "Building botany course lectures…"
  for src in "$LECTURES_DIR"/main_*.typ; do
    compile_one "$src"
  done
  echo ""
  echo "Done — ${ok} succeeded, ${fail} failed."
fi
