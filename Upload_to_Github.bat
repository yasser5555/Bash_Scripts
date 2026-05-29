@echo off
title GitHub Upload Script

echo ============================
echo      GitHub Upload Tool
echo ============================

:: Ask for repo URL
set /p repo=Enter GitHub repository URL: 

:: Ask for commit message
set /p commitMsg=Enter commit message: 

:: Ask for branch name
set /p branch=Enter branch name (default: main): 

:: Default branch
if "%branch%"=="" set branch=main

:: Check if git exists
git --version >nul 2>&1
if errorlevel 1 (
    echo Git is not installed or not added to PATH.
    pause
    exit /b
)

:: Initialize git if .git does not exist
if not exist ".git" (
    echo Initializing Git repository...
    git init
)

:: Check if origin exists
git remote | findstr "origin" >nul
if errorlevel 1 (
    git remote add origin %repo%
) else (
    echo Remote origin already exists.
)

:: Add files
echo Adding files...
git add .

:: Commit files
echo Committing files...
git commit -m "%commitMsg%"

:: Set branch
git branch -M %branch%

:: Push files
echo Pushing to GitHub...
git push -u origin %branch%

echo.
echo Done!
pause