# Sprint M04 — Setup & Submission Guide

## Step 1: Set up the Anaconda environment (one-time)

Open **Anaconda Prompt** and run:

```bash
# Navigate to your cloned repo folder
cd path\to\your\sprint-m04-fork

# Create the conda environment from the spec file
conda env create -f environment.yml

# Activate it
conda activate semaxis

# Register it as a Jupyter kernel
python -m ipykernel install --user --name semaxis --display-name "Python 3 (semaxis)"
```

---

## Step 2: Run the notebook

### Option A — Jupyter Lab / Notebook (interactive)

```bash
conda activate semaxis
jupyter lab
```

1. Open `M04_Sprint_Project_-_Semantic_Axes.ipynb`
2. In the top-right corner, select kernel **"Python 3 (semaxis)"**
3. The first cell (`!pip install ipywidgets ...`) is now **uncommented** — leave it as is
4. **Restart Kernel** (Kernel → Restart Kernel…)
5. Run all cells from **Cell 2 onwards** (skip re-running cell 1 if packages already installed),  
   or simply do **Kernel → Restart & Run All**

### Option B — Command line (fully automated, no UI)

```bash
conda activate semaxis
bash run.sh
```

This executes the notebook end-to-end and saves both figures to `figs/`.

---

## Step 3: Push to GitHub

```bash
conda activate semaxis
bash git_push.sh
```

The script creates **atomic commits** (one per logical change) and pushes to your fork.

Commit sequence it will create:
1. `add raw cities dataset to data/`
2. `add environment.yml and requirements.txt for reproducibility`
3. `add run.sh: one-command pipeline (conda + nbconvert)`
4. `add notebook: define semantic axes and score cities`
5. `add figures: semantic_map.png and geographic_map.png`
6. `add NOTE.md: observations, surprising findings, third-axis proposal`

---

## Step 4: Submit

Post the URL of your **forked GitHub repo** to Brightspace.

---

## Grading checklist

| Criterion | Status |
|-----------|--------|
| Atomic git history (no `final`, `final2`) | ✅ `git_push.sh` handles this |
| Reproducible pipeline (`bash run.sh` works fresh) | ✅ Tested |
| Documentation (NOTE.md explains axes + figure) | ✅ |
| Viz quality (colorblind-friendly, legends outside cluster) | ✅ |
| Task completion (2 axes, 2 plots, observations) | ✅ |
| Cosine distance ≥ 0.30 on both axes | ✅ Axis 1: 0.738, Axis 2: 0.613 |
