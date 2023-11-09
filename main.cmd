@echo off
echo Abriendo ventanas...

:start
start "" cmd /c echo Ventana && timeout /nobreak /t 1 >nul
timeout /nobreak /t 30 >nul
taskkill /f /im cmd.exe
