@echo off
echo Iniciando "broma"...

setlocal EnableDelayedExpansion

:start
set /a "x=!random! %% 800"
set /a "y=!random! %% 600"
powershell -WindowStyle Hidden -Command "& {Start-Process cmd -ArgumentList '/c echo Ventana' -WindowStyle Normal -NoNewWindow -WorkingDirectory ~ -Verb RunAs -PassThru | %{Set-WindowPos $_.MainWindowHandle -X %x% -Y %y%})}"
timeout /nobreak /t 2 >nul
goto start
