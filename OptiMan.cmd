@echo off
&color 0A
&title Optimización y Mantenimiento

:: Ocultar comandos
echo off

:: Comprobar si se está ejecutando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
   echo Este script requiere privilegios de administrador.
   timeout 3 >nul
   exit
)

:inicio 
choice /m "Optimización y Mantenimiento"
echo.
choice /c 1234 /m "Elija una opción:"
echo 1 - Optimización inicial
echo 2 - Mantenimiento regular
echo 3 - Optimización y mantenimiento
echo 4 - Salir
set /p opcion=

if "%opcion%"=="1" goto :optimizacion
if "%opcion%"=="2" goto :mantenimiento
if "%opcion%"=="3" goto :optimizacion_mantenimiento
if "%opcion%"=="4" exit

:optimizacion  
cls
echo ============================
echo    OPTIMIZACIÓN INICIAL
echo ============================
call :confirmar_optimizacion

:: Optimización inicial
REM Deshabilitar efectos visuales
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f  
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f  
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f

REM Deshabilitar animaciones de inicio  
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

REM Establecer programa de inicio
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Optimizar sistema" /t REG_SZ /d "%windir%\system32\cmd.exe /c %~dp0optimizar.bat" /f

REM Deshabilitar soluciones problemas automáticos
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v DoReport /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v DisableQueryRemoteServer /t REG_DWORD /d 0 /f  
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v EnableQueryRemoteServer /t REG_DWORD /d 0 /f

REM Deshabilitar telemetría
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

REM Deshabilitar servicios innecesarios 
sc config AarSvc start= disabled
sc config AJRouter start= disabled
sc config ALG start= disabled
REM ...

REM Desactivar tareas programadas innecesarias
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable 
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable
REM ...

REM Otros comandos útiles
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61  
cleanmgr /verylowdisk
compact /compactos:always
wevtutil cl Setup & wevtutil cl System & wevtutil cl Security & wevtutil cl Application & fsutil usn deletejournal /d C:

goto menu

:mantenimiento
cls 
echo ===============================  
echo    MANTENIMIENTO REGULAR
echo ===============================
call :confirmar_mantenimiento

:: Mantenimiento regular
REM Reparar archivos dañados 
sfc /scannow

REM Reparar componentes de Windows
DISM /Online /Cleanup-Image /RestoreHealth

REM Desfragmentar disco 
defrag /C /H

REM Limpiar caché DNS
ipconfig /flushdns

REM Liberar memoria
wmic MEMORYCHUNK WHERE "NOT Allocated" CALL Free

REM Limpiar archivos temporales  
cleanmgr /sagerun:1

REM Optimizar unidad SSD
defrag /C /L /V

REM Reducir tamaño Restore Points 
vssadmin Resize ShadowStorage /For=C: /On=C: /MaxSize=10GB

REM Reparar permisos archivos sistema
icacls %windir%\system32\*.* /reset /T 

REM Reconstruir índices de búsqueda
cmd /c start /wait wsreset.exe -q

REM Reparar registro
chkdsk /f 
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth  

REM Otros 
compact /U /S /A /I /F /Q
cleanmgr /sagerun:1 
wevtutil cl Setup & wevtutil cl System & wevtutil cl Security & wevtutil cl Application & fsutil usn deletejournal /d C:
powercfg -devicequery wake_armed
powercfg -deviceenablewake "PCI\VEN_10EC&DEV_8168&SUBSYS_816810EC&REV_06\4&1D62F95B&0&00E0"

goto menu

:optimizacion_mantenimiento
cls
echo ===================================
echo   OPTIMIZACIÓN Y MANTENIMIENTO
echo ===================================
call :confirmar_optimizacion_mantenimiento 

:: Optimización inicial
REM Comandos de optimización...

:: Mantenimiento regular
REM Comandos de mantenimiento...

goto menu

:confirmar_optimizacion
echo La optimización inicial puede afectar el rendimiento temporalmente.
set /p continuar=¿Desea continuar? (S/N):
if /i "%continuar%" neq "S" goto menu

:confirmar_mantenimiento  
echo El mantenimiento regular mejora el rendimiento a largo plazo.
set /p continuar=¿Desea continuar? (S/N): 
if /i "%continuar%" neq "S" goto menu

:confirmar_optimizacion_mantenimiento
echo La optimización y mantenimiento mejoran el rendimiento del sistema.
set /p continuar=¿Desea continuar? (S/N):
if /i "%continuar%" neq "S" goto menu

:finalizado
choice /m "Proceso finalizado" /c Y /d Y /t 1 /n

:reiniciar
choice /m "¿Desea reiniciar el equipo para aplicar los cambios?"
if errorlevel 2 (
  shutdown /r /t 0
)
