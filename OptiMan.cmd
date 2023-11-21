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

schtasks /change /tn "\\Microsoft\\Windows\\WindowsBackup\\AutomaticBackup" /disable

schtasks /change /tn "\\Microsoft\\Windows\\WindowsUpdate\\Automatic App Update" /disable 

schtasks /change /tn "\\Microsoft\\Windows\\DiskDiagnostic\\Microsoft-Windows-DiskDiagnosticDataCollector" /disable

echo ✅ Tareas programadas desactivadas con éxito.

echo 🧹 Liberando memoria RAM...

wmic MEMORYCHUNK WHERE "NOT Allocated" CALL Free

echo 👍 Memoria RAM liberada.

echo 🧹 Limpiando caché DNS... 

ipconfig /flushdns

echo 👍 Caché DNS limpiada.

powercfg -h off

echo 🔌 Hibernación deshabilitada. 

echo 🧹 Deshabilitando indexación de búsqueda...

sc config wsearch start= disabled

echo 👍 Indexación de búsqueda deshabilitada.

echo 🧹 Limpiando prefetch...

del /q /f /s %SYSTEMDRIVE%\Windows\Prefetch\*.*  

echo 👍 Prefetch limpiado.

echo 🧹 Deshabilitando Superfetch...

sc config SysMain start= disabled

echo 👍 Superfetch deshabilitado.

echo 🧹 Limpiando registro...

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches" /va /f

echo 👍 Registro limpiado.

goto :eof

:mantenimiento

echo 🔄 Deshabilitando hibernación...

powercfg -h off 

echo ✅ Hibernación deshabilitada.

echo 🔄 Reduciendo tamaño Restore Points...

vssadmin Resize ShadowStorage /On=C: /For=C: /MaxSize=10GB 

echo ✅ Tamaño de Restore Points reducido.

echo 🔄 Revisando integridad de archivos del sistema...
sfc /scannow
echo ✅ Integridad de archivos revisada.

echo 🔄 Reparando componentes de Windows...
DISM /Online /Cleanup-Image /RestoreHealth
echo ✅ Componentes de Windows reparados.

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

echo - Liberar memoria RAM  

echo - Limpiar caché DNS

echo - Deshabilitar hibernación 

echo - Deshabilitar indexación de búsqueda

echo - Limpiar prefetch

echo - Deshabilitar Superfetch

echo - Limpiar registro

echo.

echo 🚨 ¡ADVERTENCIA! Esta acción puede afectar el funcionamiento del sistema. ¿Desea continuar? (S/N)

set /p confirmar=

if /i "%confirmar%" neq "S" exit /b

goto :eof

:confirmar_mantener  

echo Confirmación: Se realizará el siguiente mantenimiento: 

echo - Deshabilitar hibernación

echo - Reducir tamaño Restore Points

echo. 

echo 🚨 ¡ADVERTENCIA! Esta acción puede llevar tiempo. ¿Desea continuar? (S/N)

set /p confirmar=

if /i "%confirmar%" neq "S" exit /b

goto :eof

:confirmar_optimizar_mantener

echo Confirmación: Se realizará la siguiente optimización y mantenimiento:

echo - Deshabilitar servicios innecesarios

echo - Desactivar tareas programadas innecesarias 

echo - Liberar memoria RAM

echo - Limpiar caché DNS

echo - Deshabilitar hibernación

echo - Deshabilitar indexación de búsqueda  

echo - Limpiar prefetch

echo - Deshabilitar Superfetch

echo - Limpiar registro

echo - Reducir tamaño Restore Points

echo.

echo 🚨 ¡ADVERTENCIA! Esta acción puede afectar el funcionamiento del sistema y llevar tiempo. ¿Desea continuar? (S/N) 

set /p confirmar=

if /i "%confirmar%" neq "S" exit /b

goto :eof

:final

echo Proceso finalizado.

timeout 5 > nul

exit /b
