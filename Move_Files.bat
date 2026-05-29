@echo off
setlocal enabledelayedexpansion

:: Ask user for extension
set /p ext=Enter file extension (example: txt): 

:: Ask user for folder name
set /p folder=Enter folder name: 

:: Check if folder exists
if exist "%folder%" (
    echo Folder "%folder%" already exists.
) else (
    mkdir "%folder%"
    echo Folder "%folder%" created.
)

:: Move files
set moved=0

for %%f in (*.%ext%) do (
    move "%%f" "%folder%" >nul
    echo Moved: %%f
    set moved=1
)

:: If no files found
if !moved! == 0 (
    echo No .%ext% file s found.
)

echo Done.
pause