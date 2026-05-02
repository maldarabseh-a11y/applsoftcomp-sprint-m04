#!/usr/bin/env bash
# ============================================================
# git_push.sh — Atomic git history setup + push to GitHub fork
#
# USAGE:
#   1. cd into your FORKED repo root (already cloned locally)
#   2. Copy all project files into it (see structure below)
#   3. bash git_push.sh
#   4. Post the GitHub URL to Brightspace
#
# Expected repo structure before running:
#   .
#   ├── data/
#   │   └── cities.csv
#   ├── figs/
#   │   ├── semantic_map.png
#   │   └── geographic_map.png
#   ├── M04_Sprint_Project_-_Semantic_Axes.ipynb
#   ├── environment.yml
#   ├── requirements.txt
#   ├── run.sh
#   └── NOTE.md
# ============================================================
set -euo pipefail

# ── Sanity checks ────────────────────────────────────────────
if [ ! -d ".git" ]; then
  echo "ERROR: Not inside a git repository."
  echo "  cd into your cloned fork first, then run this script."
  exit 1
fi

if [ ! -f "M04_Sprint_Project_-_Semantic_Axes.ipynb" ]; then
  echo "ERROR: Notebook not found. Make sure you copied all files."
  exit 1
fi

echo "Git remote: $(git remote get-url origin 2>/dev/null || echo 'none')"
echo ""

# ── Configure git identity if not set ────────────────────────
if [ -z "$(git config user.email 2>/dev/null)" ]; then
  read -rp "Your git email: " GIT_EMAIL
  read -rp "Your git name:  " GIT_NAME
  git config user.email "$GIT_EMAIL"
  git config user.name  "$GIT_NAME"
fi

# ── Helper: stage + commit only if there are changes ─────────
commit_if_changed() {
  local msg="$1"; shift
  git add "$@"
  if git diff --cached --quiet; then
    echo "  (no changes for: $msg)"
  else
    git commit -m "$msg"
    echo "  committed: $msg"
  fi
}

# ════════════════════════════════════════════════════════════
# Atomic commits — one logical unit per commit
# ════════════════════════════════════════════════════════════

echo "Building atomic git history..."

# 1. Raw data
commit_if_changed "add raw cities dataset to data/" \
    data/cities.csv

# 2. Conda / pip environment spec
commit_if_changed "add environment.yml and requirements.txt for reproducibility" \
    environment.yml requirements.txt

# 3. Reproducible pipeline script
commit_if_changed "add run.sh: one-command pipeline (conda + nbconvert)" \
    run.sh

# 4. Notebook — axis definitions and semantic scoring
commit_if_changed "add notebook: define semantic axes and score cities" \
    "M04_Sprint_Project_-_Semantic_Axes.ipynb"

# 5. Generated figures
commit_if_changed "add figures: semantic_map.png and geographic_map.png" \
    figs/semantic_map.png figs/geographic_map.png

# 6. Written observations
commit_if_changed "add NOTE.md: observations, surprising findings, third-axis proposal" \
    NOTE.md

echo ""
echo "Commit log:"
git log --oneline -8
echo ""

# ── Push ─────────────────────────────────────────────────────
read -rp "Push to origin/main now? [y/N] " PUSH
if [[ "$PUSH" =~ ^[Yy]$ ]]; then
  git push origin main
  echo ""
  REPO_URL=$(git remote get-url origin | sed 's/\.git$//')
  echo "Pushed! Submit this URL to Brightspace:"
  echo "  $REPO_URL"
else
  echo "Push skipped. Run 'git push origin main' when ready."
fi
