@echo off
chcp 65001 > nul

set "name="
set "lastname="
set "age="
set "personaldata="
set "continue="

set /p "name=Introduzca su nombre: "
set /p "lastname=Introduzca su apellido: "
set /p "age=Introduzca su edad: "
set /p "personaldata=Introduzca algún dato personal: "
set /p "continue=¿Desea continuar? (S/N): "

if /i "%continue%"=="s" goto hackeo
goto cancelado

:hackeo
echo Iniciando hackeo...
ping localhost -n 2 > nul
echo Descifrando contraseñas...
ping localhost -n 2 > nul
echo Accediendo a la cámara web...
ping localhost -n 2 > nul
echo Monitorizando llamadas telefónicas...
ping localhost -n 2 > nul
echo Leyendo historial de navegación...
ping localhost -n 2 > nul
echo Extrayendo fotos y archivos...
ping localhost -n 2 > nul
echo Enviando datos a servidor secreto...
ping localhost -n 2 > nul
echo.
echo Todos sus datos me pertenecen ahora jeje
echo Estaré vigilándolo...
goto finalizar

:cancelado
echo Operación cancelada.

:finalizar
pause
