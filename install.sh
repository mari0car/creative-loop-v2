#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/creative"

# Wipe any prior install (v1 or partial v2) so stale files can't linger
rm -rf "$SKILL_DIR"
mkdir -p "$SKILL_DIR"

cp SKILL.md "$SKILL_DIR/SKILL.md"

echo "Installed creative skill → $SKILL_DIR/SKILL.md"
echo "Try: /creative <your problem>"
