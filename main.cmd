@echo off
echo Iniciando "broma"...

:start
start "Ventana %time%" cmd /c echo Ventana && timeout /nobreak /t 2 >nul
goto start
