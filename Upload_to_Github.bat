```bat
@echo off

:: ============================================
:: GitHub Upload Script
:: A simple tool to upload files to GitHub
:: ============================================

:: Set CMD window title
title GitHub Upload Script

echo ============================
echo      GitHub Upload Tool
echo ============================

:: ============================================
:: Ask user for repository URL
:: Example:
:: https://github.com/username/repo.git
:: ============================================
set /p repo=Enter GitHub repository URL: 

:: ============================================
:: Ask user for commit message
:: Example:
:: Initial upload
:: Fixed bugs
:: ============================================
set /p commitMsg=Enter commit message: 

:: ============================================
:: Ask user for branch name
:: If empty -> use "main"
:: ============================================
set /p branch=Enter branch name (default: main): 

if "%branch%"=="" set branch=main

:: ============================================
:: Ask if GitHub repository is empty
:: y = empty repository
:: n = repository already contains commits/files
:: ============================================
set /p emptyRepo=Is the GitHub repository empty? (y/n): 

echo.

:: ============================================
:: Upload options
:: 1 = Upload all files
:: 2 = Upload selected files only
:: ============================================
echo Upload Options:
echo [1] Upload all files
echo [2] Upload specific files

set /p uploadChoice=Choose option (1/2): 

:: ============================================
:: Check if Git is installed
:: ============================================
git --version >nul 2>&1

if errorlevel 1 (
    echo.
    echo Git is not installed or not added to PATH.
    echo Install Git first then try again.
    pause
    exit /b
)

:: ============================================
:: Initialize Git repository if .git does not exist
:: ============================================
if not exist ".git" (

    echo.
    echo Initializing Git repository...

    git init
)

:: ============================================
:: Check if remote "origin" already exists
:: ============================================
git remote | findstr "origin" >nul

:: ============================================
:: Add remote repository if origin does not exist
:: ============================================
if errorlevel 1 (

    echo.
    echo Connecting repository to GitHub...

    git remote add origin %repo%
)

:: ============================================
:: Rename current branch
:: Example:
:: main
:: dev
:: master
:: ============================================
git branch -M %branch%

:: ============================================
:: Show warning if repository is not empty
:: We do NOT pull automatically to avoid conflicts
:: ============================================
if /I "%emptyRepo%"=="n" (

    echo.
    echo WARNING:
    echo This GitHub repository is NOT empty.
    echo Push may fail if histories are different.
    echo.
)

:: ============================================
:: Upload ALL files
:: ============================================
if "%uploadChoice%"=="1" (

    echo.
    echo Adding all files...

    :: Add every file/folder in current directory
    git add .
)

:: ============================================
:: Upload SPECIFIC files only
:: ============================================
if "%uploadChoice%"=="2" (

    echo.
    echo Available files:
    echo ----------------------------

    :: Display files in current folder
    dir /b

    echo.
    echo Example:
    echo app.js index.html style.css
    echo.

    :: Ask user for multiple file names
    set /p files=Enter file names separated by spaces: 

    :: Loop through every entered file
    for %%f in (%files%) do (

        :: Check if file exists
        if exist "%%f" (

            echo Adding %%f ...

            :: Add selected file
            git add "%%f"

        ) else (

            echo File %%f not found.
        )
    )
)

:: ============================================
:: Create Git commit
:: ============================================
echo.
echo Creating commit...

git commit -m "%commitMsg%"

:: ============================================
:: Push files to GitHub
:: ============================================
echo.
echo Pushing files to GitHub...

git push -u origin %branch%

:: ============================================
:: Finish message
:: ============================================
echo.
echo ============================================
echo Upload completed successfully!
echo ============================================

pause