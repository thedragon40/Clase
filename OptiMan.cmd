@echo off
chcp 65001 > nul
setlocal EnableExtensions EnableDelayedExpansion

:: Comprobación de privilegios elevados 
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Este script requiere privilegios administrativos. Ejecútelo como administrador.
    pause
    exit /b 1
)

:menuPrincipal
cls
echo ---------- MENÚ PRINCIPAL ----------
echo 1. Optimización 
echo 2. Mantenimiento
echo 3. Salir

set /p opcion=Elige una opción: 
if !opcion! equ 1 call :optimizacion
if !opcion! equ 2 call :mantenimiento
if !opcion! equ 3 exit /b
goto :menuPrincipal

:confirmarEjecucion
echo.
set /p confirmacion=¿Desea continuar? (S/N): 
if /i "!confirmacion!" neq "S" goto :menuPrincipal
echo.

:confirmarOptimizacion
echo.
set /p confirmacion=¿Estás seguro de que quieres optimizar el sistema con el perfil de "%1"? Este perfil hace lo siguiente:
if "%2"=="optimizarTodos" (
    call :mostrarDetalles "Todos los perfiles" "optimizarTodos"
) else (
    call :mostrarDetalles "%1" "%2"
)
echo Elige tu opción: Sí (S) o No (N): 
set /p confirmacion=
if /i "!confirmacion!" neq "S" goto :menuPrincipal
echo.

goto :eof


:optimizacion
cls 
echo ========= OPTIMIZACIÓN =========
echo 1. Juegos
echo 2. Ofimática
echo 3. Multimedia
echo 4. Todos
echo 5. Volver atrás

set /p perfil=Perfil: 
if !perfil! equ 1 call :confirmarOptimizacion "Juegos" "optimizarJuegos"
if !perfil! equ 2 call :confirmarOptimizacion "Ofimática" "optimizarOfimatica"
if !perfil! equ 3 call :confirmarOptimizacion "Multimedia" "optimizarMultimedia"
if !perfil! equ 4 call :confirmarOptimizacion "Todos los perfiles" "optimizarTodos"
if !perfil! equ 5 goto :menuPrincipal

goto :menuPrincipal


:ejecutarConConfirmacion
echo %~1
call %2
echo.
goto :confirmarEjecucion

:optimizarConConfirmacion
echo.
echo Detalles de la optimización:
call :mostrarDetalles %1
echo.
call :ejecutarConConfirmacion "¿Desea aplicar esta optimización?" %2
echo.

goto :menuPrincipal

:mostrarDetalles
echo %~1
echo ---------------------------
if "%2"=="optimizarJuegos" (
    echo 1. Desactivar servicios innecesarios para juegos.
    echo    - Se desactivarán servicios en segundo plano que no son esenciales para juegos.
    echo 2. Ajustar configuración de red para priorizar juegos.
    echo    - Se realizarán ajustes para dar prioridad a la conexión de red durante juegos.
    echo 3. Deshabilitar animaciones y efectos visuales.
    echo    - Se deshabilitarán animaciones y efectos visuales para mejorar el rendimiento.
) else if "%2"=="optimizarOfimatica" (
    echo 1. Ajustar configuración visual para mejorar rendimiento en tareas de ofimática.
    echo    - Se realizarán ajustes visuales para optimizar el rendimiento en tareas de ofimática.
) else if "%2"=="optimizarMultimedia" (
    echo 1. Desactivar ahorro de energía en modo de espera para mejorar la reproducción multimedia.
    echo    - Se desactivará el ahorro de energía en modo de espera para mejorar la reproducción multimedia.
) else if "%2"=="optimizarTodos" (
    echo 1. Aplicar todas las optimizaciones disponibles.
    echo    - Se aplicarán todas las optimizaciones disponibles para mejorar el rendimiento general del sistema.
) else if "%2"=="limpiarDisco" (
    echo 1. Limpiar disco eliminando archivos temporales y no necesarios.
    echo    - Se eliminarán archivos temporales y no necesarios para liberar espacio en disco.
) else if "%2"=="verificarDisco" (
    echo 1. Verificar y corregir errores en el disco.
    echo    - Se realizará una verificación y corrección de errores en el disco.
) else if "%2"=="escanearSistema" (
    echo 1. Escanear y reparar archivos del sistema.
    echo    - Se escanearán y repararán archivos del sistema que estén dañados o faltantes.
) else if "%2"=="restaurarSaludImagen" (
    echo 1. Restaurar la salud de la imagen del sistema utilizando DISM.
    echo    - Se restaurará la salud de la imagen del sistema utilizando la herramienta DISM.
) else if "%2"=="mantenimientoTodos" (
    echo 1. Aplicar todas las acciones de mantenimiento disponibles.
    echo    - Se aplicarán todas las acciones de mantenimiento disponibles para garantizar el buen funcionamiento del sistema.
) else (
    REM Agrega más bloques de condiciones según sea necesario
)
echo ---------------------------
echo.

goto :eof


:optimizarJuegos
REM Comandos específicos para optimización de juegos
sc config "wuauserv" start=disabled || goto :error
sc config "wudfsvc" start=disabled || goto :error
netsh int tcp set global autotuninglevel=normal || goto :error
netsh int tcp set global chimney=enabled || goto :error
echo Optimización completa para juegos.
goto :eof

:optimizarOfimatica
REM Comandos específicos para optimización de ofimática
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f || goto :error
echo Optimización completa para ofimática.
goto :eof

:optimizarMultimedia
REM Comandos específicos para optimización multimedia
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 || goto :error
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 || goto :error
echo Optimización completa para multimedia.
goto :eof

:optimizarTodos
call :optimizarJuegos
call :optimizarOfimatica
call :optimizarMultimedia
goto :eof

:mantenimiento
cls
echo ========= MANTENIMIENTO =========
echo 1. Limpiar disco
echo 2. Verificar disco
echo 3. Escanear archivos del sistema
echo 4. Restaurar salud de la imagen del sistema
echo 5. Todos

set /p mantenimiento=Mantenimiento:
if !mantenimiento! equ 1 call :confirmarEjecucion "Limpiar disco" limpiarDisco
if !mantenimiento! equ 2 call :confirmarEjecucion "Verificar disco" verificarDisco
if !mantenimiento! equ 3 call :confirmarEjecucion "Escanear archivos del sistema" escanearSistema
if !mantenimiento! equ 4 call :confirmarEjecucion "Restaurar salud de la imagen del sistema" restaurarSaludImagen
if !mantenimiento! equ 5 call :confirmarEjecucion "Aplicar todas las acciones de mantenimiento" mantenimientoTodos

goto :menuPrincipal

:limpiarDisco
REM Comandos específicos para limpiar disco
cleanmgr /sagerun:1 || goto :error
echo Limpiar disco completo.
goto :eof

:verificarDisco
REM Comandos específicos para verificar disco
chkdsk /f || goto :error
echo Verificación de disco completa.
goto :eof

:escanearSistema
REM Comandos específicos para escanear archivos del sistema
sfc /scannow || goto :error
echo Escaneo de archivos del sistema completo.
goto :eof

:restaurarSaludImagen
REM Comandos específicos para restaurar salud de la imagen del sistema
DISM /Online /Cleanup-Image /RestoreHealth || goto :error
echo Restauración de salud de la imagen del sistema completa.
goto :eof

:mantenimientoTodos
call :limpiarDisco
call :verificarDisco
call :escanearSistema
call :restaurarSaludImagen
goto :eof

:error
echo Error al aplicar configuración.
pause
exit /b
