batch
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
echo Se va a proceder a realizar las siguientes tareas de mantenimiento:
echo - Limpieza de archivos temporales
echo - Desfragmentación de disco duro
echo - Comprobación de errores en disco
echo - Reparación de archivos de sistema
echo - Optimización de imagen de Windows
echo - Limpieza de registro
echo.

set /p confirmar=¿Desea continuar con el mantenimiento? (S/N): 
if /i "%confirmar%"=="S" goto :continuar 
if /i "%confirmar%"=="N" goto :fin

:continuar
:: Preguntar si configurar ejecución periódica
set /p config=¿Desea configurar la ejecución automática periódica? (S/N): 
if /i "%config%"=="S" goto :configurar
if /i "%config%"=="N" goto :fin

:configurar
set /p tiempo=¿Cada cuántos días quiere ejecutar el mantenimiento?
schtasks /create /sc daily /mo %tiempo% /tn "Mantenimiento PC" /tr "mantenimiento.cmd"
echo Mantenimiento programado para ejecutarse cada %tiempo% días.
echo.

:fin 
echo Proceso finalizado.
echo.

:: Detectar versión
ver | find "5.2" > nul 
if %errorlevel% equ 0 (
  echo Windows Server 2003
  goto :Server2003
)

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
:Server2003
echo El mantenimiento no es compatible con Windows Server 2003.
goto :EOF

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
echo Realizando mantenimiento en Windows XP...
echo.
echo Limpieza de archivos temporales...
del %temp%\* /s /f /q > nul
echo Desfragmentación de disco duro...
ipconfig /flushdns > nul
echo Comprobación de errores en disco...
netsh int ip reset > nul
echo Reparación de archivos de sistema...
msg * /time:60 "Mantenimiento completado en Windows XP"
echo.
goto :EOF

:executeVista
echo Realizando mantenimiento en Windows Vista...
echo.
echo Limpieza de archivos temporales y desfragmentación de disco duro...
cleanmgr /sageset:99 > nul
cleanmgr /sagerun:99 > nul
echo Comprobación de errores en disco...
diskpart /slimp all > nul
echo Reparación de archivos de sistema...
msg * /time:60 "Mantenimiento completado en Windows Vista"
echo.
goto :EOF

:executeWin7
echo Realizando mantenimiento en Windows 7...
echo.
echo Limpieza de archivos temporales y desfragmentación de disco duro...
cleanmgr /verylowdisk > nul
diskcleanup /autoclean > nul
defrag C: /U /V > nul
echo Comprobación de errores en disco...
chkdsk /f > nul
echo Reparación de archivos de sistema...
sfc /scannow > nul
echo Optimización de imagen de Windows...
msg * /time:60 "Mantenimiento completado en Windows 7"
echo.
goto :EOF

:executeWin8
echo Realizando mantenimiento en Windows 8...
echo.
echo Análisis y limpieza de componentes de imagen...
Dism /online /Cleanup-Image /AnalyzeComponentStore > nul
Dism /online /Cleanup-Image /StartComponentCleanup > nul
echo Limpieza de archivos temporales y comprobación de errores en disco...
cleanmgr /verylowdisk > nul
chkdsk /spotfix > nul
echo Reparación de archivos de sistema...
msg * /time:60 "Mantenimiento completado en Windows 8"
echo.
goto :EOF

:executeWin81
echo Realizando mantenimiento en Windows 8.1...
echo.
echo Limpieza de archivos temporales y comprobación de errores en disco...
cleanmgr /verylowdisk > nul
chkdsk /f > nul
echo Reparación de archivos de sistema y comprobación de salud de la imagen...
sfc /scannow > nul
Dism /Online /Cleanup-Image /CheckHealth > nul
Dism /online /Cleanup-Image /ScanHealth > nul
Dism /Online /Cleanup-Image /RestoreHealth > nul
echo Optimización de imagen de Windows...
msg * /time:60 "Mantenimiento completado en Windows 8.1"
echo.
goto :EOF

:executeWin10
echo Realizando mantenimiento en Windows 10...
echo.
echo Limpieza de archivos temporales y comprobación de errores en disco...
cleanmgr /verylowdisk > nul
chkdsk /f > nul
echo Reparación de archivos de sistema y restauración de la salud de la imagen...
sfc /scannow > nul
DISM /Online /Cleanup-Image /RestoreHealth > nul
echo Desfragmentación de disco duro...
defrag C: /U /V > nul
echo Optimización de imagen de Windows...
msg %username% /time:60 "Mantenimiento completado en Windows 10"
echo.
goto :EOF

:executeWin11
echo Realizando mantenimiento en Windows 11...
echo.
echo Limpieza de archivos temporales y comprobación de errores en disco...
cleanmgr /verylowdisk > nul
chkdsk /f > nul
echo Reparación de archivos de sistema y restauración de la salud de la imagen...
sfc /scannow > nul
DISM /Online /Cleanup-Image /RestoreHealth > nul
echo Desfragmentación de disco duro...
defrag C: /U /V > nul
echo Optimización de imagen de Windows...
msg %username% /time:60 "Mantenimiento completado en Windows 11"
echo.
goto :EOF
