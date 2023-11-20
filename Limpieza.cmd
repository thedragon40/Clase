@echo off
chcp 65001 > nul
title Mantenimiento del PC
color 0E
cls 

:: Mensaje inicial  
color 0B
echo Este asistente realizará tareas de 
echo optimizacion y mantenimiento en su 
echo equipo, como:
echo.
echo - Limpieza de archivos temporales
echo - Analisis de disco  
echo - Desfragmentacion
echo - Optimizacion del sistema
echo.
echo Presione una tecla para continuar.
pause >nul

:: Comprobar permisos 

net session >nul 2>&1
if %errorLevel% == 0 (
  echo Permisos de administrador OK.
) else (
  color 0C
  echo Requiere ejecucion como administrador.
  timeout /t 5 >nul
  exit
)  

:: Detectar SO
color 0D 
for /f "tokens=4-5 delims=. " %%i in ('ver') do (
  set version=%%i.%%j
  echo Sistema Operativo Windows %%i.%%j detectado. 
)

:: Comandos segun SO
if "%version%"=="5.1" goto :XP
if "%version%"=="6.0" goto :Vista
if "%version%"=="6.1" goto :Win7
if "%version%"=="6.2" goto :Win8
if "%version%"=="6.3" goto :Win81
if "%version%"=="10.0" goto :Win10
goto :Win11

:XP
color 0E
del %temp%\* /s /f /q
ipconfig /flushdns
netsh int ip reset
goto :finalizar

:Vista  
color 0B
cleanmgr /sagerun:99
diskpart /s limpiar todo  
DISM /Online /Cleanup-Image /RestoreHealth
chkdsk /f
goto :finalizar

:Win7
color 0D
cleanmgr /verylowdisk
chkdsk /f 
sfc /scannow
defrag C:
DISM /Online /Cleanup-Image /Restorehealth
goto :finalizar

:Win8
color 0C  
Dism /Cleanup-Image /StartComponentCleanup
chkdsk /spotfix
DISM /Online /Cleanup-Image /RestoreHealth
cleanmgr /verylowdisk
goto :finalizar

:Win81 
color 0E
cleanmgr /verylowdisk 
chkdsk /f
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
defrag C: /U /V  
goto :finalizar

:Win10
color 0A
cleanmgr /verylowdisk  
chkdsk /f 
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth  
defrag C: /U /V
goto :finalizar

:Win11
color 0F
cleanmgr /verylowdisk
chkdsk /f  
sfc /scannow  
DISM /Online /Cleanup-Image /Restorehealth
defrag C: /U /V
goto :finalizar

:finalizar

:finalizar 
color 0A
:: Mostrar progreso
for /L %%A in (1,1,100) do (
  cls
  echo Progreso: [%%A%%%]
  ping -n 2 localhost >nul 
)

:: Preguntas finales 
color 0C
set /p reiniciar=¿Desea reiniciar la PC ahora? (S/N)
if /i "%reiniciar%"=="S" (
  shutdown /r /t 0
)

:: Mensaje final
color 0F
echo Mantenimiento completado.
