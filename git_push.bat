@echo off
REM ============================================================
REM git_push.bat — Atomic git history setup + push to GitHub fork
REM
REM USAGE:
REM   1. cd into your FORKED repo root (already cloned locally)
REM   2. Copy all project files into it (see structure below)
REM   3. git_push.bat
REM   4. Post the GitHub URL to Brightspace
REM
REM Expected repo structure before running:
REM   .
REM   ├── data/
REM   │   └── cities.csv
REM   ├── figs/
REM   │   ├── semantic_map.png
REM   │   └── geographic_map.png
REM   ├── M04_Sprint_Project_-_Semantic_Axes.ipynb
REM   ├── environment.yml
REM   ├── requirements.txt
REM   ├── run.sh
REM   └── NOTE.md
REM ============================================================
setlocal enabledelayedexpansion

REM ── Sanity checks ────────────────────────────────────────────
if not exist ".git" (
  echo ERROR: Not inside a git repository.
  echo   cd into your cloned fork first, then run this script.
  exit /b 1
)

if not exist "M04_Sprint_Project_-_Semantic_Axes.ipynb" (
  echo ERROR: Notebook not found. Make sure you copied all files.
  exit /b 1
)

set "GIT_REMOTE="
for /f "delims=" %%R in ('git remote get-url origin 2^>nul') do set "GIT_REMOTE=%%R"
if defined GIT_REMOTE (
  echo Git remote: !GIT_REMOTE!
) else (
  echo Git remote: none
)
echo.

set "GIT_EMAIL="
for /f "delims=" %%E in ('git config user.email 2^>nul') do set "GIT_EMAIL=%%E"
if not defined GIT_EMAIL (
  set /p "GIT_EMAIL=Your git email: "
  set /p "GIT_NAME=Your git name: "
  git config user.email "!GIT_EMAIL!"
  git config user.name "!GIT_NAME!"
)

REM ── Helper: stage + commit only if there are changes ─────────
call :commit_if_changed "add raw cities dataset to data/" "data\cities.csv"
call :commit_if_changed "add environment.yml and requirements.txt for reproducibility" "environment.yml" "requirements.txt"
call :commit_if_changed "add run.sh: one-command pipeline (conda + nbconvert)" "run.sh"
call :commit_if_changed "add notebook: define semantic axes and score cities" "M04_Sprint_Project_-_Semantic_Axes.ipynb"
call :commit_if_changed "add figures: semantic_map.png and geographic_map.png" "figs\semantic_map.png" "figs\geographic_map.png"
call :commit_if_changed "add NOTE.md: observations, surprising findings, third-axis proposal" "NOTE.md"

echo.
echo Commit log:
git log --oneline -8
echo.

REM ── Push ─────────────────────────────────────────────────────
set "CURRENT_BRANCH="
for /f "delims=" %%B in ('git branch --show-current') do set "CURRENT_BRANCH=%%B"
if not defined CURRENT_BRANCH set "CURRENT_BRANCH=main"
set /p "PUSH=Push to origin/%CURRENT_BRANCH% now? [y/N] "
if /i "%PUSH%"=="y" (
  git push origin !CURRENT_BRANCH!
  set "REPO_URL="
  for /f "delims=" %%U in ('git remote get-url origin 2^>nul') do set "REPO_URL=%%U"
  if /i "!REPO_URL:~-4!"==".git" set "REPO_URL=!REPO_URL:~0,-4!"
  echo.
  echo Pushed! Submit this URL to Brightspace:
  echo   !REPO_URL!
) else (
  echo Push skipped. Run "git push origin %CURRENT_BRANCH%" when ready.
)

exit /b

:commit_if_changed
set "msg=%~1"
shift
set "files="
:commit_loop
if "%~1"=="" goto commit_if_changed_done
  git add "%~1"
  shift
goto commit_loop

:commit_if_changed_done
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "%msg%"
  echo   committed: %msg%
) else (
  echo   (no changes for: %msg%)
)
exit /b
