@echo off
echo Iniciando "broma"...

:start
start "" cmd /c echo Ventana && timeout /nobreak /t 2 >nul
timeout /nobreak /t 30 >nul
taskkill /f /im cmd.exe

echo Has sido "bromeado". && pause
