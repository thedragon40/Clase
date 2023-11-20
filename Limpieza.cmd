@echo off
chcp 65001 > nul

:: Verificar si tiene permisos de administrador
openfiles > nul 2>&1
if %errorlevel% == 0 (
  echo Tiene permisos de administrador. Continuando...
  goto mantenimiento
) else (
  echo Se requieren permisos de administrador.
  set /p elevar="¿Desea reiniciar el script como administrador? (S/N)"
  if /i "%elevar%"=="S" (
    echo Reiniciando el script con permisos elevados...
    powershell Start-Process -FilePath '%0' -verb runas
    exit
  ) else (
    echo Operación cancelada por el usuario.
    goto fin
  )  
)

:mantenimiento
:: Preguntar si desea continuar
echo.
echo =========================
echo    Tareas de mantenimiento
echo =========================
echo.
echo - Limpieza de archivos temporales 
echo - Desfragmentación de disco duro
echo - Comprobación de errores en disco  
echo - Reparación de archivos de sistema
echo - Optimización de imagen de Windows
echo - Limpieza de registro
echo.
echo =========================
echo.
set /p confirmar=¿Desea continuar? (S/N):
if /i "%confirmar%"=="S" goto :continuar 
if /i "%confirmar%"=="N" goto :fin

:continuar
:: Preguntar si configurar ejecución periódica
echo.
echo ============================
echo   Ejecución automática periódica
echo ============================
echo.
set /p config=¿Desea configurar la ejecución automática periódica? (S/N): 
if /i "%config%"=="S" goto :configurar
if /i "%config%"=="N" goto :fin

:configurar
set /p tiempo=¿Cada cuántos días quiere ejecutar el mantenimiento?
echo.
echo Programando la ejecución periódica...
schtasks /create /sc daily /mo %tiempo% /tn "Mantenimiento PC" /tr "mantenimiento.cmd"
echo Mantenimiento programado para ejecutarse cada %tiempo% días.
echo.
echo ============================
echo.

:fin 
echo.
echo ===========================
echo       Proceso finalizado
echo ===========================
echo.
echo.

:: Detectar versión
ver | find "5.1" > nul 
if %errorlevel% equ 0 (
  echo Windows XP
  goto :XP
)

ver | find "6.0" > nul
if %errorlevel% equ 0 (
  echo Windows Vista
  goto :Vista   
)

ver | find "6.1" > nul
if %errorlevel% equ 0 (
  echo Windows 7
  goto :Win7  
)

ver | find "6.2" > nul 
if %errorlevel% equ 0 (
  echo Windows 8
  goto :Win8
)

ver | find "6.3" > nul
if %errorlevel% equ 0 ( 
  echo Windows 8.1
  goto :Win81
)

ver | find "10.0" > nul   
if %errorlevel% equ 0 (
  echo Windows 10
  goto :Win10
) 

:: Por defecto asumimos Windows 11
echo Windows 11
goto :Win11

:: Código para detectar versión y ejecutar mantenimiento
:XP 
call :executeXP
goto :EOF

:Vista
call :executeVista
goto :EOF

:Win7
call :executeWin7
goto :EOF

:Win8
call :executeWin8
goto :EOF

:Win81
call :executeWin81
goto :EOF

:Win10
call :executeWin10
goto :EOF

:Win11
call :executeWin11
goto :EOF

:executeXP
echo Realizando el mantenimiento en Windows XP...
echo Limpiando archivos temporales...
del %temp%\* /s /f /q
echo.
echo Limpieza completada.
echo.
echo Actualizando configuración de red...
ipconfig /flushdns
netsh int ip reset 
echo.
echo Actualización completada.
echo.
msg * /time:60 "Mantenimiento completado en Windows XP"
goto :EOF

:executeVista
echo Realizando el mantenimiento en Windows Vista...
echo Configurando limpieza de archivos temporales...
cleanmgr /sageset:99
cleanmgr /sagerun:99 
echo.
echo Limpieza completada.
echo.
echo Desfragmentando disco duro...
diskpart /slimp all
echo.
echo Desfragmentación completada.
echo.
msg * /time:60 "Mantenimiento completado en Windows Vista"
goto :EOF

:executeWin7
echo Realizando el mantenimiento en Windows 7...
echo Limpieza de archivos temporales...
cleanmgr /verylowdisk
echo.
echo Limpieza completada.
echo.
echo Limpieza automática de disco...
diskcleanup /autoclean
echo.
echo Limpieza automática completada.
echo.
echo Desfragmentando disco duro...
defrag C: /U /V 
echo.
echo Desfragmentación completada.
echo.
echo Comprobación de errores en disco...
chkdsk /f
echo.
echo Comprobación de errores en disco completada.
echo.
echo Reparación de archivos de sistema...
sfc /scannow
echo.
echo Reparación de archivos de sistema completada.
echo.
msg * /time:60 "Mantenimiento completado en Windows 7"  
goto :EOF

:executeWin8
echo Realizando el mantenimiento en Windows 8...
echo Analizando componentes del sistema...
Dism /online /Cleanup-Image /AnalyzeComponentStore
echo.
echo Análisis completado.
echo.
echo Limpiando componentes del sistema...
Dism /online /Cleanup-Image /StartComponentCleanup
echo.
echo Limpieza completada.
echo.
echo Limpieza de archivos temporales...
cleanmgr /verylowdisk
echo.
echo Limpieza completada.
echo.
echo Comprobación de errores en disco...
chkdsk /spotfix
echo.
echo Comprobación de errores en disco completada.
echo.
msg * /time:60 "Mantenimiento completado en Windows 8"
goto :EOF

:executeWin81
echo Realizando el mantenimiento en Windows 8.1...
echo Limpieza de archivos temporales...
cleanmgr /verylowdisk
echo.
echo Limpieza completada.
echo.
echo Comprobación de errores en disco...
chkdsk /f
echo.
echo Comprobación de errores en disco completada.
echo.
echo Reparación de archivos de sistema...
sfc /scannow
echo.
echo Reparación de archivos de sistema completada.
echo.
echo Comprobando integridad de la imagen de Windows...
Dism /Online /Cleanup-Image /CheckHealth
Dism /online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /RestoreHealth
echo.
echo Comprobación de imagen de Windows completada.
echo.
msg * /time:60 "Mantenimiento completado en Windows 8.1"
goto :EOF

:executeWin10
echo Realizando el mantenimiento en Windows 10...
echo Limpieza de archivos temporales...
cleanmgr /verylowdisk  
echo.
echo Limpieza completada.
echo.
echo Comprobación de errores en disco...
chkdsk /f
echo.
echo Comprobación de errores en disco completada.
echo.
echo Reparación de archivos de sistema...
sfc /scannow
echo.
echo Reparación de archivos de sistema completada.
echo.
echo Restaurando la imagen de Windows...
DISM /Online /Cleanup-Image /RestoreHealth 
echo.
echo Restauración de imagen de Windows completada.
echo.
echo Desfragmentando disco duro...
defrag C: /U /V
echo.
echo Desfragmentación completada.
echo.
msg %username% /time:60 "Mantenimiento completado en Windows 10" 
goto :EOF

:executeWin11
echo Realizando el mantenimiento en Windows 11...
echo Limpieza de archivos temporales...
cleanmgr /verylowdisk
echo.
echo Limpieza completada.
echo.
echo Comprobación de errores en disco...
chkdsk /f 
echo.
echo Comprobación de errores en disco completada.
echo.
echo Reparación de archivos de sistema...
sfc /scannow
echo.
echo Reparación de archivos de sistema completada.
echo.
echo Restaurando la imagen de Windows...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo Restauración de imagen de Windows completada.
echo.
echo Desfragmentando disco duro...
defrag C: /U /V  
echo.
echo Desfragmentación completada.
echo.
msg %username% /time:60 "Mantenimiento completado en Windows 11"
goto :EOF
