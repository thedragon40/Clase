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
echo Elija una opción:
echo 1 - Optimización
echo 2 - Mantenimiento 
echo 3 - Optimización y Mantenimiento
echo 4 - Salir

set /p opcion=
if "%opcion%"=="1" goto optimizar
if "%opcion%"=="2" goto mantener
if "%opcion%"=="3" goto optimizar_mantener
if "%opcion%"=="4" exit /b

:optimizar
echo 🚀 Iniciando optimización...
call :confirmar_optimizar
call :optimizacion
goto final

:mantener 
echo 🚀 Iniciando mantenimiento... 
call :confirmar_mantener
call :mantenimiento
goto final

:optimizar_mantener
echo 🚀 Iniciando optimización y mantenimiento...
call :confirmar_optimizar_mantener
call :optimizacion
call :mantenimiento
goto final

:optimizacion
echo 🔄 Deshabilitando servicios innecesarios...
sc config "wuauserv" start= disabled
sc config "wercplsupport" start= disabled
sc config "RemoteRegistry" start= disabled
sc config "sppsvc" start= disabled
echo ✅ Servicios deshabilitados con éxito.

echo 🔄 Desactivando tareas programadas innecesarias...
schtasks /change /tn "\Microsoft\Windows\WindowsBackup\AutomaticBackup" /disable
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
echo ✅ Tareas programadas desactivadas con éxito.

goto :eof

:mantenimiento
echo 🔄 Limpiando archivos temporales...
cleanmgr /sagerun:1
echo ✅ Archivos temporales limpiados con éxito.

echo 🔄 Desfragmentando unidades (puede tardar)...
defrag /c /o
echo ✅ Unidades desfragmentadas con éxito.

echo 🔄 Verificando y reparando errores en el disco...
chkdsk /f
echo ✅ Errores en el disco verificados y reparados con éxito.

goto :eof

:retry_command
%*
if %errorlevel% neq 0 (
    echo ❌ Error al ejecutar el comando: %*
    echo Intente nuevamente.
    exit /b
)
goto :eof

:confirmar_optimizar
echo Confirmación: Se realizará la siguiente optimización:
echo - Deshabilitar servicios innecesarios
echo - Desactivar tareas programadas innecesarias
echo.
echo 🚨 ¡ADVERTENCIA! Esta acción puede afectar el funcionamiento del sistema. ¿Desea continuar? (S/N)

set /p confirmar=
if /i "%confirmar%" neq "S" exit /b

goto :eof

:confirmar_mantener
echo Confirmación: Se realizará el siguiente mantenimiento:
echo - Limpiar archivos temporales
echo - Desfragmentar unidades
echo - Verificar y reparar errores en el disco
echo.
echo 🚨 ¡ADVERTENCIA! Esta acción puede llevar tiempo. ¿Desea continuar? (S/N)

set /p confirmar=
if /i "%confirmar%" neq "S" exit /b

goto :eof

:confirmar_optimizar_mantener
echo Confirmación: Se realizará la siguiente optimización y mantenimiento:
echo - Deshabilitar servicios innecesarios
echo - Desactivar tareas programadas innecesarias
echo - Limpiar archivos temporales
echo - Desfragmentar unidades
echo - Verificar y reparar errores en el disco
echo.
echo 🚨 ¡ADVERTENCIA! Esta acción puede afectar el funcionamiento del sistema y llevar tiempo. ¿Desea continuar? (S/N)

set /p confirmar=
if /i "%confirmar%" neq "S" exit /b

goto :eof

:final
echo Proceso finalizado.
timeout 5 > nul
exit /b
