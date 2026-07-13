@echo off
title Grafika Dev Server
cd /d "%~dp0"

echo ============================================
echo  Grafika Intelligent Scheduling - Dev Mode
echo ============================================
echo.

:: Check .env
if not exist .env (
    echo [INFO] Membuat .env dari .env.example...
    copy .env.example .env >nul
    echo [WARN] Edit .env dan isi OPENAI_API_KEY terlebih dahulu!
)

:: Check prerequisites
where go >nul 2>&1 || ( echo [ERROR] Golang tidak ditemukan. & exit /b 1 )
where node >nul 2>&1 || ( echo [ERROR] Node.js tidak ditemukan. & exit /b 1 )
where python >nul 2>&1 || ( echo [ERROR] Python tidak ditemukan. & exit /b 1 )

echo [OK] Semua prerequisite terpenuhi.
echo.

:: Install ML dependencies
if not exist ml\venv (
    echo [ML] Membuat virtual environment...
    cd ml && python -m venv venv && cd ..
)
echo [ML] Install dependencies...
start "Grafika ML" cmd /c "cd /d "%~dp0ml" && call venv\Scripts\activate.bat && pip install -r requirements.txt -q && echo [ML Ready] & uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"

timeout /t 5 /nobreak >nul

:: Start Backend
echo [Backend] Menjalankan Go server di :8080...
start "Grafika Backend" cmd /c "cd /d "%~dp0backend" && go run ./cmd/server"

timeout /t 3 /nobreak >nul

:: Start Frontend
echo [Frontend] Menjalankan Next.js di :3000...
start "Grafika Frontend" cmd /c "cd /d "%~dp0frontend" && npm run dev"

echo.
echo ============================================
echo  Semua service sudah di-start:
echo    Frontend : http://localhost:3000
echo    Backend  : http://localhost:8080
echo    ML       : http://localhost:8000
echo ============================================
echo.
echo Tekan sembarang tombol untuk menutup window ini
pause >nul
