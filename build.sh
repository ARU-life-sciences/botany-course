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
  local out="$2"
  local label="$3"
  local outname
  outname="$(basename "$out")"

  printf "  %-30s → %s ... " "$label" "$outname"
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
  echo "Watching for changes (Ctrl-C to stop)…"
  for src in "$LECTURES_DIR"/main_*.typ; do
    name="$(basename "$src" .typ)"
    typst watch --root "$COURSE_ROOT" "$src" "$LECTURES_DIR/${name}.pdf" &
  done
  typst watch --root "$COURSE_ROOT" "$LECTURES_DIR/famfinder.typ"       "$LECTURES_DIR/famfinder.pdf" &
  typst watch --root "$COURSE_ROOT" "$LECTURES_DIR/family_rosaceae.typ" "$LECTURES_DIR/family_rosaceae.pdf" &
  typst watch --root "$COURSE_ROOT" "$LECTURES_DIR/worksheet_leaves.typ" "$LECTURES_DIR/worksheet_leaves.pdf" &
  typst watch --root "$COURSE_ROOT" "$LECTURES_DIR/worksheet_flowers.typ" "$LECTURES_DIR/worksheet_flowers.pdf" &
  wait
else
  echo "Building botany course lectures…"
  for src in "$LECTURES_DIR"/main_*.typ; do
    name="$(basename "$src" .typ)"
    compile_one "$src" "$LECTURES_DIR/${name}.pdf" "${name}.typ"
  done
  echo ""
  echo "Building handouts…"
  compile_one "$LECTURES_DIR/famfinder.typ"         "$LECTURES_DIR/famfinder.pdf"         "famfinder.typ"
  compile_one "$LECTURES_DIR/family_rosaceae.typ"   "$LECTURES_DIR/family_rosaceae.pdf"   "family_rosaceae.typ"
  compile_one "$LECTURES_DIR/worksheet_leaves.typ"  "$LECTURES_DIR/worksheet_leaves.pdf"  "worksheet_leaves.typ"
  compile_one "$LECTURES_DIR/worksheet_flowers.typ" "$LECTURES_DIR/worksheet_flowers.pdf" "worksheet_flowers.typ"
  echo ""
  echo "Done — ${ok} succeeded, ${fail} failed."
fi
