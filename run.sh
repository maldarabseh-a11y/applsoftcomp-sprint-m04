#!/usr/bin/env bash
# ============================================================
# Sprint M04 — Reproducible Pipeline
# Usage:   bash run.sh
# Effect:  Installs deps, executes notebook, saves both figures
#          to figs/semantic_map.png and figs/geographic_map.png
# ============================================================
set -euo pipefail

echo "========================================"
echo " Sprint M04 — Semantic Axes Pipeline"
echo "========================================"

# ── 1. Environment setup ─────────────────────────────────────
# Option A: Anaconda (preferred — matches environment.yml)
if command -v conda &>/dev/null; then
    echo "[1/3] Conda detected."
    # Create env if it doesn't already exist
    if ! conda env list | grep -q "^semaxis "; then
        echo "      Creating conda env 'semaxis' from environment.yml ..."
        conda env create -f environment.yml
    else
        echo "      Conda env 'semaxis' already exists — skipping create."
    fi
    # Activate and install kernel
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate semaxis
    python -m ipykernel install --user --name semaxis --display-name "Python 3 (semaxis)" 2>/dev/null || true

# Option B: pip fallback (e.g., GitHub Codespace / CI)
elif command -v uv &>/dev/null; then
    echo "[1/3] uv detected — installing from requirements.txt ..."
    uv pip install --system -r requirements.txt
else
    echo "[1/3] pip fallback — installing from requirements.txt ..."
    pip install --quiet -r requirements.txt
fi

# ── 2. Create output directory ───────────────────────────────
mkdir -p figs
echo "[2/3] Output directory ready."

# ── 3. Execute notebook ───────────────────────────────────────
echo "[3/3] Executing notebook ..."
jupyter nbconvert \
    --to notebook \
    --execute \
    --inplace \
    --ExecutePreprocessor.timeout=300 \
    --ExecutePreprocessor.kernel_name=python3 \
    "M04_Sprint_Project_-_Semantic_Axes.ipynb"

echo ""
echo "Done. Outputs:"
ls -lh figs/
