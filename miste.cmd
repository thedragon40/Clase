@echo off
chcp 65001 > nul
cls

set /p name="Introduzca su nombre: "
set /p lastname="Introduzca su apellido: "
set /p age="Introduzca su edad: "
set /p personaldata="Introduzca algún dato personal: "
set /p continue="¿Desea continuar? (S/N): "

if %continue%==S goto hackeo
if %continue%==s goto hackeo
goto cancelado

:hackeo
cls 
echo Iniciando hackeo...
ping localhost -n 3 >nul
echo Descifrando contraseñas... 
ping localhost -n 2 >nul
echo Accediendo a camara web...
ping localhost -n 2 >nul  
echo Monitorizando llamadas telefonicas...
ping localhost -n 2 >nul
echo Leyendo historial de navegacion...  
ping localhost -n 2 >nul
echo Extrayendo fotos y archivos...
ping localhost -n 3 >nul
echo Enviando datos a servidor secreto...
ping localhost -n 3 >nul
echo.
echo ^<Todos sus datos me pertenecen ahora! Muajaja!^>
echo ^<Le estare vigilando...^>
goto finalizar

:cancelado
echo Operación cancelada.

:finalizar 
pause >nul
