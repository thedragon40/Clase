@echo off
chcp 65001 > nul
title Mantenimiento del PC
color 0E
cls

echo Bienvenido al Asistente de Mantenimiento 
echo Este programa realizará tareas de  
echo optimización en su equipo.

set /p continuar=Presione ENTER para continuar o Ctrl+C para cancelar.

:: Comprobar permisos de administrador  
openfiles >nul 2>&1 || (
  echo Requiere permisos de administrador.
  powershell start %0 '-verb runas' 
  exit /b  
)

:: Detectar sistema operativo
for /f "tokens=4-5 delims=. " %%i in ('ver') do set version=%%i.%%j
if "%version%"=="5.1" echo Windows XP && goto :XP
if "%version%"=="6.0" echo Windows Vista && goto :Vista
if "%version%"=="6.1" echo Windows 7 && goto :Win7
if "%version%"=="6.2" echo Windows 8 && goto :Win8
if "%version%"=="6.3" echo Windows 8.1 && goto :Win81
if "%version%"=="10.0" echo Windows 10 && goto :Win10
echo Sistema operativo no compatible. && goto :EOF

:XP
del %temp%\* /s /f /q
ipconfig /flushdns
netsh int ip reset
goto :finalizar

:Vista
cleanmgr /sageset:99  
cleanmgr /sagerun:99
diskpart /s limpiar todo
goto :finalizar

:Win7
cleanmgr /verylowdisk
chkdsk /f  
sfc /scannow
defrag C: 
goto :finalizar

:Win8
Dism /Cleanup-Image /StartComponentCleanup 
chkdsk /spotfix
goto :finalizar 

:Win81  
cleanmgr /verylowdisk
chkdsk /f 
sfc /scannow
Dism /Online /Cleanup-Image /RestoreHealth
goto :finalizar

:Win10
cleanmgr /verylowdisk
chkdsk /f  
sfc /scannow  
DISM /Online /Cleanup-Image /RestoreHealth
defrag C: /U /V
goto :finalizar

:Win11 
cleanmgr /verylowdisk
chkdsk /f
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth  
defrag C: /U /V  
goto :finalizar

:finalizar
:: Mostrar barra de progreso 
for /L %%A in (1,1,100) do (
  cls
  echo Progreso: [%%A%%%]
  ping -n 2 localhost >nul 
)

:: Preguntar por programación automática
set /p programar=¿Desea programar el mantenimiento automático? (S/N): 
if /i "%programar%"=="S" (
  set /p intervalo=¿Cada cuantos días?  
  schtasks /create /sc daily /mo %intervalo% /tn "Mantenimiento" /tr "mantenimiento.cmd"
  echo Programado para cada %intervalo% días. 
)

:: Preguntar por reinicio  
set /p reiniciar=¿Desea reiniciar la PC ahora? (S/N)
if /i "%reiniciar%"=="S" (
  shutdown /r /t 0
)

echo.
echo Proceso finalizado.
