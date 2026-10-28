#!/usr/bin/env bash
# Install the Instagram skills into Mistral Code (Vibe).
#
# Vibe reads the open Agent Skills spec (SKILL.md with YAML frontmatter), the
# same format this repo already uses for Claude Code and Codex. This script
# copies each skill directory plus the shared references/ and lib/ trees into
# a single install root, keeping the relative ../../ paths intact (they
# resolve correctly from the new location).
#
# Modes:
#   ./scripts/vibe-install.sh               user install (~/.vibe/skills)
#   ./scripts/vibe-install.sh --project     project install (./.vibe/skills)
#   ./scripts/vibe-install.sh --uninstall   remove the installed skills
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLE_NAME="instagram-skills"
MODE="user"
PROJECT=0
UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --project) PROJECT=1 ;;
    --uninstall) UNINSTALL=1 ;;
    *) echo "Unknown option: $arg (use --project or --uninstall)" >&2; exit 1 ;;
  esac
done
if [ "$UNINSTALL" = 1 ]; then
  MODE="uninstall"
elif [ "$PROJECT" = 1 ]; then
  MODE="project"
fi

if [ "$PROJECT" = 1 ]; then
  DEST_ROOT="$PWD/.vibe/skills/$BUNDLE_NAME"
else
  DEST_ROOT="${VIBE_HOME:-$HOME/.vibe}/skills/$BUNDLE_NAME"
fi

SKILL_DIRS=(ig-caption-writer ig-carousel-planner ig-hook-extractor \
            ig-hashtag-strategist ig-humanizer ig-content-planner \
            ig-repurposer ig-profile-optimizer ig-audience-insights)

if [ "$MODE" = "uninstall" ]; then
  if [ -d "$DEST_ROOT" ]; then
    rm -rf "$DEST_ROOT"
    echo "Removed $DEST_ROOT"
  else
    echo "Nothing installed at $DEST_ROOT"
  fi
  exit 0
fi

for skill in "${SKILL_DIRS[@]}"; do
  if [ ! -f "$REPO_ROOT/skills/$skill/SKILL.md" ]; then
    echo "Missing skills/$skill/SKILL.md in $REPO_ROOT" >&2
    exit 1
  fi
done

mkdir -p "$DEST_ROOT/skills"
cp -R "$REPO_ROOT/references" "$DEST_ROOT/references"
cp -R "$REPO_ROOT/lib" "$DEST_ROOT/lib"
cp "$REPO_ROOT/SKILL.md" "$DEST_ROOT/SKILL.md"
cp "$REPO_ROOT/requirements.txt" "$DEST_ROOT/requirements.txt" 2>/dev/null || true

for skill in "${SKILL_DIRS[@]}"; do
  src="$REPO_ROOT/skills/$skill"
  dst="$DEST_ROOT/skills/$skill"
  rm -rf "$dst"
  # No path rewriting needed: from <dest>/skills/<skill>/SKILL.md the existing
  # ../../references/ and ../../lib/ links resolve to the shared trees copied
  # next to the skills directory above.
  cp -R "$src" "$dst"
done

echo "Installed 9 Instagram skills to $DEST_ROOT"
echo "Top-level bundle skill: $DEST_ROOT/SKILL.md"
if [ "$PROJECT" = 0 ]; then
  echo "Restart your Vibe session (or run /reload-plugins) to pick them up."
fi
