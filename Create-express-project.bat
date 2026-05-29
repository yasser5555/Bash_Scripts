@echo off
setlocal enabledelayedexpansion

set /p PROJECT_NAME=Enter project name: 

if "%PROJECT_NAME%"=="" (
    echo  Project name cannot be empty!
    exit /b 1
)

echo  Creating project: %PROJECT_NAME%
mkdir "%PROJECT_NAME%"
cd "%PROJECT_NAME%" || exit /b

REM ===== Backend =====
echo Setting up backend...
mkdir server
cd server || exit /b

echo  Initializing npm...
call npm init -y || goto :error

echo Installing dependencies...
call npm install express mysql2 dotenv cors express-session express-mysql-session cookie-parser nodemailer npm install jsonwebtoken  || goto :error
call npm install nodemon --save-dev || goto :error

type nul > index.js
type nul > .env

mkdir src
cd src
mkdir controllers databases models routes
cd ..
cd ..
echo happy Hunting >_<