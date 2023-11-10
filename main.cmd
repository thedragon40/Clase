@echo off
chcp 65001 > nul

REM Crear múltiples ventanas de CMD y mostrar mensajes en ellas
for /l %%i in (1, 1, 30) do (
    start cmd /k "!mensajes[%%i]!"
)

REM Esperar 10 segundos
timeout /t 10 /nobreak

REM Cerrar todas las ventanas de CMD
taskkill /f /im cmd.exe
