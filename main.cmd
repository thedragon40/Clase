@echo off
chcp 65001 > nul

for /l %%i in (1, 1, 30) do (
  start cmd /k
)

timeout /t 10 /nobreak
taskkill /f /im cmd.exe

:inicio
@echo off
setlocal

set "mensaje=¿Estás contento con lo sucedido?"
set "titulo=Pregunta"

set /a x=%random% %% 300 + 1 
set /a y=%random% %% 300 + 1

:pregunta
set /p respuesta="[%mensaje%] (S/N) "
if /i "%respuesta%"=="S" goto fin
if /i "%respuesta%"=="N" goto mover
echo Respuesta inválida. Intenta de nuevo.
goto pregunta

:mover
set /a x=%random% %% 300 + 1
set /a y=%random% %% 300 + 1
MessageBox %mensaje% %titulo% 0 0 %x% %y%
goto pregunta

:fin
endlocal
exit /b

call :inicio
