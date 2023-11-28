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

echo 1. Limpiar archivos temporales
echo 2. Limpiar archivos temporales de Internet Explorer
echo 3. Limpiar archivos temporales de archivos descargados
echo 4. Limpiar archivos temporales de actualizaciones de Windows
echo 5. Desfragmentar y optimizar unidades
echo 6. Comprobar y reparar errores en la unidad del sistema
echo 7. Eliminar archivos temporales del sistema de Windows
echo 8. Limpiar la caché de archivos temporales de Internet Explorer
echo 9. Desactivar el seguimiento de usuario de Windows
echo 10. Eliminar historial de navegación de Internet Explorer
echo 11. Salir
echo.
set /p option= Seleccione una opcion:

if %option%==1 goto :Option1
if %option%==2 goto :Option2
if %option%==3 goto :Option3
if %option%==4 goto :Option4
if %option%==5 goto :Option5
if %option%==6 goto :Option6
if %option%==7 goto :Option7
if %option%==8 goto :Option8
if %option%==9 goto :Option9
if %option%==10 goto :Option10
if %option%==11 goto :Exit

:Option1
echo.
echo Limpiando archivos temporales...
echo.
del /s /q %temp%\*.*
del /s /q %windir%\Temp\*.*
echo.
echo Limpieza de archivos temporales finalizada.
echo.
pause
exit

:Option2
echo.
echo Limpiando archivos temporales de Internet Explorer...
echo.
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
echo.
echo Limpieza de archivos temporales de Internet Explorer finalizada.
echo.
pause
exit

:Option3
echo.
echo Limpiando archivos temporales de archivos descargados...
echo.
del /s /q %userprofile%\Downloads\*.*
echo.
echo Limpieza de archivos temporales de archivos descargados finalizada.
echo.
pause
exit

:Option4
echo.
echo Limpiando archivos temporales de actualizaciones de Windows...
echo.
del /s /q %windir%\SoftwareDistribution\Download\*.*
echo.
echo Limpieza de archivos temporales de actualizaciones de Windows finalizada.
echo.
pause
exit

:Option5
echo.
echo Desfragmentando y optimizando unidades...
echo.
defrag /U /V
echo.
echo Desfragmentacion y optimizacion de unidades finalizada.
echo.
pause
exit

:Option6
echo.
echo Comprobando y reparando errores en la unidad del sistema...
echo.
sfc /scannow
echo.
echo Comprobacion y reparacion de errores en la unidad del sistema finalizada.
echo.
pause
exit

:Option7
echo.
echo Eliminando archivos temporales del sistema de Windows...
echo.
del /s /q %windir%\Prefetch\*.*
del /s /q %windir%\Temp\*.*
echo.
echo Eliminacion de archivos temporales del sistema de Windows finalizada.
echo.
pause
exit

:Option8
echo.
echo Limpiando la caché de archivos temporales de Internet Explorer...
echo.
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
echo.
echo Limpieza de la caché de archivos temporales de Internet Explorer finalizada.
echo.
pause
exit

:Option9
echo.
echo Desactivando el seguimiento de usuario de Windows...
echo.
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f
echo.
echo Desactivacion del seguimiento de usuario de Windows finalizada.
echo.
pause
exit

:Option10
echo.
echo Eliminando historial de navegación de Internet Explorer...
echo.
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
echo.
echo Eliminacion del historial de navegacion de Internet Explorer finalizada.
echo.
pause
exit

:Exit
exit
