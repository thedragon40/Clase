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
if "%opcion%"=="1" call :optimizacion
if "%opcion%"=="2" call :mantenimiento 
if "%opcion%"=="3" exit /b
goto :menuPrincipal

:optimizacion
cls
echo ========= OPTIMIZACIÓN =========
echo 1. Juegos
echo 2. Ofimática   
echo 3. Multimedia
echo 4. Todos  
echo 5. Volver atrás
set /p perfil=Perfil:  
if "%perfil%"=="1" call :confirmarOptimizacion "Juegos" "optimizarJuegos"
if "%perfil%"=="2" call :confirmarOptimizacion "Ofimática" "optimizarOfimatica"
if "%perfil%"=="3" call :confirmarOptimizacion "Multimedia" "optimizarMultimedia" 
if "%perfil%"=="4" call :confirmarOptimizacion "Todos los perfiles" "optimizarTodos"
if "%perfil%"=="5" goto :menuPrincipal
goto :menuPrincipal

:optimizarJuegos
REM Comandos específicos para optimización de juegos
sc config "wuauserv" start=disabled || goto :error
sc config "wudfsvc" start=disabled || goto :error  
netsh int tcp set global autotuninglevel=normal || goto :error
netsh int tcp set global chimney=enabled || goto :error
bcdedit /set {default} bootmenupolicy legacy
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9e3e678f /f
powercfg -h off
echo Optimización completa para juegos.
goto :eof

:optimizarOfimatica
REM Comandos específicos para optimización de ofimática
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f || goto :error
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9e3e678f /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
echo Optimización completa para ofimática.
goto :eof

:optimizarMultimedia
REM Comandos específicos para optimización multimedia 
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 || goto :error
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 || goto :error   
powercfg -setactive SCHEME_MIN
echo Optimización completa para multimedia.
goto :eof

:mantenimiento
cls 
echo ========= MANTENIMIENTO =========
echo 1. Limpiar disco   
echo 2. Verificar disco
echo 3. Escanear archivos del sistema   
echo 4. Restaurar salud de la imagen del sistema
echo 5. Desfragmentar disco
echo 6. Limpiar caché DNS
echo 7. Reconstruir índices de búsqueda
echo 8. Reparar MBR
echo 9. Reparar BCD
echo 10. Todos
set /p mantenimiento=Mantenimiento:   
if "%mantenimiento%"=="1" call :confirmarEjecucion "Limpiar disco" limpiarDisco
if "%mantenimiento%"=="2" call :confirmarEjecucion "Verificar disco" verificarDisco
if "%mantenimiento%"=="3" call :confirmarEjecucion "Escanear archivos del sistema" escanearSistema 
if "%mantenimiento%"=="4" call :confirmarEjecucion "Restaurar salud de la imagen del sistema" restaurarSaludImagen   
if "%mantenimiento%"=="5" call :confirmarEjecucion "Desfragmentar disco" desfragmentarDisco
if "%mantenimiento%"=="6" call :confirmarEjecucion "Limpiar caché DNS" limpiarDNS
if "%mantenimiento%"=="7" call :confirmarEjecucion "Reconstruir índices de búsqueda" reconstruirIndices 
if "%mantenimiento%"=="8" call :confirmarEjecucion "Reparar MBR" repararMBR
if "%mantenimiento%"=="9" call :confirmarEjecucion "Reparar BCD" repararBCD
if "%mantenimiento%"=="10" call :confirmarEjecucion "Aplicar todas las acciones de mantenimiento" mantenimientoTodos
goto :menuPrincipal

:desfragmentarDisco
defrag C: /U /V
echo Desfragmentación de disco completa.
goto :eof

:limpiarDNS
ipconfig /flushdns
echo Limpieza de caché DNS completa.
goto :eof

:reconstruirIndices  
chkdsk /f /r
echo Reconstrucción de índices de búsqueda completa.
goto :eof

:repararMBR
bootrec /fixmbr  
echo Reparación de MBR completa.
goto :eof

:repararBCD
bcdboot C:\Windows /s C: /f ALL  
echo Reparación de BCD completa. 
goto :eof

:mantenimientoTodos
call :limpiarDisco
call :verificarDisco
call :escanearSistema
call :restaurarSaludImagen
call :desfragmentarDisco  
call :limpiarDNS
call :reconstruirIndices
call :repararMBR
call :repararBCD
goto :eof

:error 
echo Error al aplicar configuración.
pause
exit /b
