@echo off
chcp 65001 > nul

:: Comprobar si se está ejecutando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Este script requiere privilegios de administrador. Cerrando...
    timeout 2 > nul
    runas /user:Administrator "%~dpnx0"
    exit /b
)

:menu
cls
echo ============================================
echo Elija una opción:
echo ============================================
echo 1 - Optimización
echo 2 - Mantenimiento 
echo 3 - Optimización y Mantenimiento
echo 4 - Salir
echo ============================================

set /p opcion=
if "%opcion%"=="1" goto optimizar
if "%opcion%"=="2" goto mantener
if "%opcion%"=="3" goto optimizar_mantener
if "%opcion%"=="4" exit /b

:optimizar
echo Creando punto de restauración...
:: Crear punto de restauración antes de la optimización
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Antes de la Optimización", 100, 7

echo Optimización en curso...
:: Cambiar color a amarillo
color 0E

:: Código de optimización
echo Deshabilitando servicios innecesarios...
sc config "wuauserv" start= disabled
sc config "wercplsupport" start= disabled
sc config "RemoteRegistry" start= disabled
sc config "sppsvc" start= disabled
echo Servicios deshabilitados con éxito.

echo Desactivando tareas programadas innecesarias...
schtasks /change /tn "\Microsoft\Windows\WindowsBackup\AutomaticBackup" /disable
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
echo Tareas programadas desactivadas con éxito.

:: Pausa para permitir la confirmación antes de cerrar
pause
goto final

:mantener 
echo Creando punto de restauración...
:: Crear punto de restauración antes del mantenimiento
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Antes del Mantenimiento", 100, 7

echo Realizando mantenimiento...
:: Cambiar color a verde
color 0A

:: Código de mantenimiento
echo Limpiando archivos temporales...
cleanmgr /sagerun:1
echo Archivos temporales eliminados con éxito.

echo Desfragmentando unidades (puede tardar)...
defrag /c /o
echo Desfragmentación completada.

echo Verificando y reparando errores en el disco...
chkdsk /f
echo Verificación y reparación de errores completada.

:: Pausa para permitir la confirmación antes de cerrar
pause
goto final

:optimizar_mantener
echo Creando punto de restauración...
:: Crear punto de restauración antes de la optimización y mantenimiento
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Antes de la Optimización y Mantenimiento", 100, 7

echo Optimización y mantenimiento en curso...
:: Cambiar color a cian
color 0B

:: Código de optimización 
echo Deshabilitando servicios innecesarios...
sc config "wuauserv" start= disabled
sc config "wercplsupport" start= disabled
sc config "RemoteRegistry" start= disabled
sc config "sppsvc" start= disabled
echo Servicios deshabilitados con éxito.

echo Desactivando tareas programadas innecesarias...
schtasks /change /tn "\Microsoft\Windows\WindowsBackup\AutomaticBackup" /disable
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
echo Tareas programadas desactivadas con éxito.

:: Código de mantenimiento
echo Limpiando archivos temporales...
cleanmgr /sagerun:1
echo Archivos temporales eliminados con éxito.

echo Desfragmentando unidades (puede tardar)...
defrag /c /o
echo Desfragmentación completada.

echo Verificando y reparando errores en el disco...
chkdsk /f
echo Verificación y reparación de errores completada.

:: Pausa para permitir la confirmación antes de cerrar
pause
goto final

:final
:: Restaurar color a blanco
color 07
echo Proceso finalizado.
echo.
timeout 5 > nul
exit /b
