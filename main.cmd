@echo off
echo Abriendo ventanas...

:start
start "" cmd /c echo Ventana && timeout /nobreak /t 30 >nul
goto start
