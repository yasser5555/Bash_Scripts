@echo off
setlocal enabledelayedexpansion

set /p PROJECT_NAME=Enter project name:

if "%PROJECT_NAME%"=="" (
    echo Project name cannot be empty!
    exit /b 1
)

echo Creating project: %PROJECT_NAME%

mkdir "%PROJECT_NAME%"
cd "%PROJECT_NAME%" || exit /b

REM ==================================================
REM ================= ROOT PACKAGE ===================
REM ==================================================

echo Creating root package.json...

(
echo {
echo   "name": "%PROJECT_NAME%",
echo   "version": "1.0.0",
echo   "private": true,
echo   "scripts": {
echo     "client": "cd client && npm start",
echo     "server": "cd server && npx nodemon server.js",
echo     "dev": "concurrently \"npm run server\" \"npm run client\"",
echo      "report": "cd Tools/ && nodemon Report-Generator.js"
echo   }
echo }
) > package.json

echo Installing root dependencies...

call npm install concurrently docx || goto :error

REM ==================================================
REM ================= BACKEND ========================
REM ==================================================

echo Setting up backend...

mkdir server
cd server || exit /b

call npm init -y || goto :error

echo Installing backend dependencies...

call npm install express mysql2 dotenv cors express-session express-mysql-session cookie-parser || goto :error
call npm install nodemon --save-dev || goto :error

type nul > .env
type nul > server.js

mkdir src

cd src || exit /b

REM ================= CORE =================

mkdir config
mkdir middleware
mkdir utils
mkdir shared
mkdir features

REM ================= SHARED =================

mkdir shared\services
mkdir shared\constants
mkdir shared\helpers

cd ..
cd ..

REM ==================================================
REM ================= FRONTEND =======================
REM ==================================================

echo Setting up frontend...

mkdir client
cd client || exit /b

call npx create-react-app . || goto :error

echo Installing frontend dependencies...

call npm install react-router-dom bootstrap sass || goto :error

cd src || goto :error

REM ================= CLEANUP =================

del App.css 2>nul
del App.test.js 2>nul
del logo.svg 2>nul
del reportWebVitals.js 2>nul
del setupTests.js 2>nul

REM ==================================================
REM ================= FSD STRUCTURE ==================
REM ==================================================

echo Creating Feature-Sliced Architecture...

mkdir app
mkdir pages
mkdir features
mkdir shared
mkdir widgets
mkdir entities

REM ================= APP =================

mkdir app\routes
mkdir app\layouts
mkdir app\providers
mkdir app\store

REM ================= SHARED =================

mkdir shared\components
mkdir shared\hooks
mkdir shared\utils
mkdir shared\services
mkdir shared\styles
mkdir shared\constants
mkdir shared\assets

REM ================= PAGES =================

mkdir pages\home
mkdir pages\not-found

REM ==================================================
REM ================= BASIC FILES ====================
REM ==================================================

(
echo import AppRoutes from "./app/routes/AppRoutes";
echo.
echo export default function App^(^) {
echo   return ^<AppRoutes /^>;
echo }
) > App.js

REM ================= LAYOUT =================

(
echo import { Outlet } from "react-router-dom";
echo.
echo export default function Layout^(^) {
echo   return ^(
echo     ^<^>
echo       ^<Outlet /^>
echo     ^</^>
echo   ^);
echo }
) > app\layouts\Layout.jsx

REM ================= HOME =================

(
echo export default function Home^(^) {
echo   return ^<h1^>Home Page^</h1^>;
echo }
) > pages\home\Home.jsx

REM ================= NOT FOUND =================

(
echo export default function NotFound^(^) {
echo   return ^<h1^>404 - Page Not Found^</h1^>;
echo }
) > pages\not-found\NotFound.jsx

REM ==================================================
REM ================= ROUTER =========================
REM ==================================================

(
echo import { createBrowserRouter, RouterProvider } from "react-router-dom";
echo import Layout from "../layouts/Layout";
echo import Home from "../../pages/home/Home";
echo import NotFound from "../../pages/not-found/NotFound";
echo.
echo const router = createBrowserRouter([^
echo   {
echo     path: "/",
echo     element: ^<Layout /^>,
echo     errorElement: ^<NotFound /^>,
echo     children: [
echo       {
echo         index: true,
echo         element: ^<Home /^>
echo       }
echo     ]
echo   }
echo ]);
echo.
echo export default function AppRoutes^(^) {
echo   return ^<RouterProvider router={router} /^>;
echo }
) > app\routes\AppRoutes.jsx

cd ..
cd ..

REM ==================================================
REM ================= TOOLS ==========================
REM ==================================================

echo Setting up report generator...

mkdir Tools
cd Tools || exit /b

REM ==================================================
REM ================= CONTENT.JS =====================
REM ==================================================

(
echo const today = new Date^(^);
echo.
echo const formattedDate = `${today.getFullYear^(^)}-${String^(today.getMonth^(^) + 1^).padStart^(2, "0"^)}-${String^(today.getDate^(^)^).padStart^(2, "0"^)}`;
echo.
echo const reportData = {
echo   projectName: "%PROJECT_NAME%",
echo   date: formattedDate,
echo   whatIDid: [],
echo   currentState: [],
echo   problems: [],
echo   nextSteps: [],
echo };
echo.
echo function addWhatIDid^(text^) {
echo   reportData.whatIDid.push^(text^);
echo }
echo.
echo function addCurrentState^(text^) {
echo   reportData.currentState.push^(text^);
echo }
echo.
echo function addProblem^(text^) {
echo   reportData.problems.push^(text^);
echo }
echo.
echo function addNextStep^(text^) {
echo   reportData.nextSteps.push^(text^);
echo }
echo.
echo /***********************
echo  WRITE YOUR WORK HERE
echo ************************/
echo.
echo addWhatIDid^("Implemented Product Page"^);
echo addWhatIDid^("Resolved cart display bug"^);
echo.
echo addCurrentState^("Frontend is fully functional"^);
echo addCurrentState^("Backend partially integrated"^);
echo.
echo addProblem^("Cart data not saving in DB"^);
echo.
echo addNextStep^("Fix API endpoint"^);
echo addNextStep^("Test using Postman"^);
echo.
echo module.exports = reportData;
) > Content.js

REM ==================================================
REM ================= REPORT GENERATOR ===============
REM ==================================================

(
echo const fs = require^("fs"^);
echo const path = require^("path"^);
echo.
echo const {
echo   Document,
echo   Packer,
echo   Paragraph,
echo   HeadingLevel,
echo   TextRun,
echo } = require^("docx"^);
echo.
echo const reportData = require^("./Content"^);
echo.
echo async function generateReport^(^) {
echo   const doc = new Document^({
echo     sections: [
echo       {
echo         children: [
echo           new Paragraph^({
echo             text: reportData.projectName,
echo             heading: HeadingLevel.TITLE,
echo           }^),
echo.
echo           new Paragraph^({
echo             children: [
echo               new TextRun^({
echo                 text: `Date: ${reportData.date}`,
echo                 bold: true,
echo               }^),
echo             ],
echo           }^),
echo.
echo           new Paragraph^({
echo             text: "What I Did",
echo             heading: HeadingLevel.HEADING_1,
echo           }^),
echo.
echo           ...reportData.whatIDid.map^(
echo             item =^> new Paragraph^(`• ${item}`^)
echo           ^),
echo.
echo           new Paragraph^({
echo             text: "Current State",
echo             heading: HeadingLevel.HEADING_1,
echo           }^),
echo.
echo           ...reportData.currentState.map^(
echo             item =^> new Paragraph^(`• ${item}`^)
echo           ^),
echo.
echo           new Paragraph^({
echo             text: "Problems",
echo             heading: HeadingLevel.HEADING_1,
echo           }^),
echo.
echo           ...reportData.problems.map^(
echo             item =^> new Paragraph^(`• ${item}`^)
echo           ^),
echo.
echo           new Paragraph^({
echo             text: "Next Steps",
echo             heading: HeadingLevel.HEADING_1,
echo           }^),
echo.
echo           ...reportData.nextSteps.map^(
echo             item =^> new Paragraph^(`• ${item}`^)
echo           ^),
echo         ],
echo       },
echo     ],
echo   }^);
echo.
echo   const reportDir = path.join^(__dirname, "..", "Report"^);
echo.
echo fs.mkdirSync(reportDir, { recursive: true });
echo.
echo   const filePath = path.join^(
echo     reportDir,
echo     `Report-${reportData.date}.docx`
echo   ^);
echo.
echo   const buffer = await Packer.toBuffer^(doc^);
echo.
echo   fs.writeFileSync^(filePath, buffer^);
echo.
echo   console.log^("Report generated successfully!"^);
echo }
echo.
echo generateReport^(^);
) > Report-Generator.js

cd ..

REM ==================================================
REM ================= REPORT =========================
REM ==================================================

mkdir Report

REM ==================================================
REM ================= README =========================
REM ==================================================

(
echo # %PROJECT_NAME%
echo.
echo Fullstack MERN Architecture with:
echo.
echo - React
echo - Express
echo - MySQL
echo - Feature-Sliced Design
echo - Report Generator
echo.
echo ## Commands
echo.
echo ```bash
echo npm run dev
echo npm run client
echo npm run server
echo npm run report
echo ```
) > README.md

echo.
echo ==================================================
echo Project Created Successfully!
echo Fullstack Architecture Ready 🚀
echo ==================================================
echo.
echo Available Commands:
echo.
echo npm run dev
echo npm run server
echo npm run client
echo npm run report
echo.

pause
exit /b 0

:error
echo.
echo ERROR: Something went wrong!
echo Check logs above.
pause
exit /b 1