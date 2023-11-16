@echo off
chcp 65001 > nul

for /l %%i in (1, 1, 30) do (
    start cmd /k
)

timeout /t 10 /nobreak

taskkill /f /im cmd.exe
