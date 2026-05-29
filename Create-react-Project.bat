@echo off
setlocal enabledelayedexpansion

set /p PROJECT_NAME=Enter project name: 

if "%PROJECT_NAME%"=="" (
    echo Project name cannot be empty!
    exit /b 1
)

echo.
echo ========================================
echo Creating project: %PROJECT_NAME%
echo ========================================
echo.

mkdir "%PROJECT_NAME%" 2>nul || goto :error
cd "%PROJECT_NAME%" || goto :error

REM ==================================================
REM =============== CREATE REACT APP =================
REM ==================================================

echo Installing React Application...
call npx create-react-app . || goto :error

REM ==================================================
REM ================= INSTALL PACKAGES ===============
REM ==================================================

echo Installing dependencies...

call npm install react-router-dom || goto :error
call npm install bootstrap || goto :error
call npm install sass || goto :error
call npm install dayjs || goto :error
call npm install aos || goto :error
call npm install axios || goto :error
call npm install @fortawesome/fontawesome-free || goto :error

REM ==================================================
REM ================= GO TO SRC ======================
REM ==================================================

cd src || goto :error

REM ==================================================
REM ================= CLEAN DEFAULT FILES ============
REM ==================================================

echo Cleaning default files...

del App.css 2>nul
del App.test.js 2>nul
del logo.svg 2>nul
del reportWebVitals.js 2>nul
del setupTests.js 2>nul

REM ==================================================
REM ================= FSD STRUCTURE ==================
REM ==================================================

echo Creating Feature-Sliced Design architecture...

REM ================= CORE LAYERS =================

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

mkdir shared\assets\images
mkdir shared\assets\fonts
mkdir shared\assets\icons

REM ================= PAGES =================

mkdir pages\home
mkdir pages\not-found

REM ==================================================
REM ================= BASIC FILES ====================
REM ==================================================

echo Creating base files...

REM ================= App.js =================

(
echo import AppRoutes from "./app/routes/AppRoutes";
echo.
echo export default function App^(^) {
echo   return ^<AppRoutes /^>;
echo }
) > App.js

REM ================= Layout.jsx =================

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

REM ================= Home.jsx =================

(
echo export default function Home^(^) {
echo   return ^(
echo     ^<div^>
echo       ^<h1^>Home Page^</h1^>
echo     ^</div^>
echo   ^);
echo }
) > pages\home\Home.jsx

REM ================= NotFound.jsx =================

(
echo export default function NotFound^(^) {
echo   return ^(
echo     ^<h1^>404 - Page Not Found^</h1^>
echo   ^);
echo }
) > pages\not-found\NotFound.jsx

REM ==================================================
REM ================= ROUTER =========================
REM ==================================================

echo Creating routing system...

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

REM ==================================================
REM ================= GLOBAL STYLE ===================
REM ==================================================

(
echo @import "bootstrap/dist/css/bootstrap.min.css";
echo @import "aos/dist/aos.css";
echo.
echo * {
echo   margin: 0;
echo   padding: 0;
echo   box-sizing: border-box;
echo }
echo.
echo body {
echo   font-family: sans-serif;
echo }
) > shared\styles\global.scss

REM ==================================================
REM ================= IMPORT GLOBAL STYLE ============
REM ==================================================

powershell -Command "(Get-Content index.js) -replace 'import ''./index.css'';', 'import ""./shared/styles/global.scss"";' | Set-Content index.js"

REM ==================================================
REM ================= ARCHITECTURE DOC ===============
REM ==================================================
cd .. 
(
echo # Architecture Guide
echo.
echo This project uses Feature-Sliced Design ^(FSD^).
echo.
echo ---
echo.
echo ## Structure
echo.
echo ```bash
echo src/
echo ├── app/
echo ├── pages/
echo ├── features/
echo ├── shared/
echo ├── widgets/
echo └── entities/
echo ```
echo.
echo ---
echo.
echo ## app/
echo Handles:
echo.
echo - Routing
echo - Layouts
echo - Providers
echo - Store
echo.
echo ---
echo.
echo ## pages/
echo Route-level pages only.
echo.
echo Example:
echo.
echo - Home
echo - Dashboard
echo - About
echo.
echo ---
echo.
echo ## features/
echo Business logic/features.
echo.
echo Example:
echo.
echo - auth
echo - posts
echo - analytics
echo.
echo ---
echo.
echo ## shared/
echo Shared reusable code.
echo.
echo Example:
echo.
echo - components
echo - hooks
echo - services
echo - styles
echo.
echo ---
echo.
echo ## widgets/
echo Large reusable UI blocks.
echo.
echo Example:
echo.
echo - Navbar
echo - Sidebar
echo - Footer
echo.
echo ---
echo.
echo ## entities/
echo Business entities/models.
echo.
echo Example:
echo.
echo - User
echo - Product
echo - Post
echo.
echo ---
echo.
echo ## Naming Convention
echo.
echo - kebab-case for folders
echo - PascalCase for components
echo - camelCase for functions
echo.
echo Example:
echo.
echo ```bash
echo features/auth/components/LoginForm.jsx
echo ```
) > arch.md

cd ..

echo.
echo ========================================
echo Project Created Successfully!
echo FSD Architecture Ready 🚀
echo ========================================
echo.

pause
exit /b 0

:error
echo.
echo ========================================
echo ERROR: Something went wrong!
echo Check the logs above.
echo ========================================
echo.

pause
exit /b 1