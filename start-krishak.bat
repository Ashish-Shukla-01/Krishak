@echo off
title KRISHAK AI engine
cd /d "%~dp0server"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is not installed. Opening the download page.
  echo Install the LTS version, then double-click this file again.
  start https://nodejs.org
  pause
  exit /b
)
node -e "process.exit(Number(process.versions.node.split('.')[0])>=20?0:1)"
if errorlevel 1 (
  echo Your Node.js is too old. Please install the latest LTS from https://nodejs.org
  start https://nodejs.org
  pause
  exit /b
)

set "KEYFILE=%USERPROFILE%\krishak-key.txt"
set "ANTHROPIC_API_KEY="
set "GEMINI_API_KEY="
set "RAWKEY="
if exist "%KEYFILE%" (
  set /p RAWKEY=<"%KEYFILE%"
  echo.
  echo A saved key was found ^(starts with %RAWKEY:~0,4%^).
  choice /c YN /n /m "Use the saved key? Press Y for yes, N to enter a different key: "
  if errorlevel 2 set "RAWKEY="
)

:check
echo %RAWKEY%| findstr /b /c:"sk-ant-" >nul && goto isant
echo %RAWKEY%| findstr /b /c:"AIza" >nul && goto isgem
echo %RAWKEY%| findstr /b /c:"AQ." >nul && goto isgem
echo.
echo Paste your API key and press Enter. Right-click in this window to paste.
echo   Free Google Gemini key starts with AQ. or AIza
echo   Paid Anthropic key starts with sk-ant-
set "RAWKEY="
set /p RAWKEY=Key: 
goto check

:isant
set "ANTHROPIC_API_KEY=%RAWKEY%"
goto go
:isgem
set "GEMINI_API_KEY=%RAWKEY%"

:go
> "%KEYFILE%" echo %RAWKEY%
echo.
echo Key accepted ^(starts with %RAWKEY:~0,4%^).
echo To switch to a different key later, delete the file krishak-key.txt in your user folder.
set "DATA_GOV_API_KEY="
set "MKEYFILE=%USERPROFILE%\krishak-mandi-key.txt"
if exist "%MKEYFILE%" set /p DATA_GOV_API_KEY=<"%MKEYFILE%"
if defined DATA_GOV_API_KEY goto mandiok
echo.
echo OPTIONAL - real mandi prices: paste your free data.gov.in API key, or just press Enter to skip.
set /p DATA_GOV_API_KEY=Mandi key: 
if defined DATA_GOV_API_KEY (> "%MKEYFILE%" echo %DATA_GOV_API_KEY%)
:mandiok
echo Starting KRISHAK. Keep this window open while you use the site.
start "" cmd /c "timeout /t 2 >nul & start http://localhost:8787"
node server.js
pause
