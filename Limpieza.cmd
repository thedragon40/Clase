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
echo Se va a proceder a realizar las siguientes tareas de mantenimiento:
echo - Limpieza de archivos temporales 
echo - Desfragmentación de disco duro
echo - Comprobación de errores en disco  
echo - Reparación de archivos de sistema
echo - Optimización de imagen de Windows
echo - Limpieza de registro

set /p confirmar=¿Desea continuar? (S/N):
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

:fin 
echo Proceso finalizado.

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
del %temp%\* /s /f /q
ipconfig /flushdns
netsh int ip reset 
msg * /time:60 "Mantenimiento completado en Windows XP"
goto :EOF

:Vista
cleanmgr /sageset:99
cleanmgr /sagerun:99 
diskpart /slimp all
msg * /time:60 "Mantenimiento completado en Windows Vista"
goto :EOF

:Win7
cleanmgr /verylowdisk
diskcleanup /autoclean
defrag C: /U /V 
chkdsk /f
sfc /scannow
msg * /time:60 "Mantenimiento completado en Windows 7"  
goto :EOF

:Win8
Dism /online /Cleanup-Image /AnalyzeComponentStore
Dism /online /Cleanup-Image /StartComponentCleanup
cleanmgr /verylowdisk
chkdsk /spotfix
msg * /time:60 "Mantenimiento completado en Windows 8"
goto :EOF

:Win81
cleanmgr /verylowdisk
chkdsk /f
sfc /scannow
Dism /Online /Cleanup-Image /CheckHealth
Dism /online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /RestoreHealth
msg * /time:60 "Mantenimiento completado en Windows 8.1"
goto :EOF

:Win10
cleanmgr /verylowdisk  
chkdsk /f
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth 
defrag C: /U /V
msg %username% /time:60 "Mantenimiento completado en Windows 10" 
goto :EOF

:Win11
cleanmgr /verylowdisk
chkdsk /f 
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
defrag C: /U /V  
msg %username% /time:60 "Mantenimiento completado en Windows 11"
goto :EOF
