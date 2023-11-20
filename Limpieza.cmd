@echo off
color 0A

:: Detectar versión de Windows

ver | find "5.1" > nul 
if %errorlevel% equ 0 (
  echo Windows XP detectado
  goto :XP
)

ver | find "6.0" > nul
if %errorlevel% equ 0 ( 
  echo Windows Vista detectado
  goto :Vista
)

ver | find "6.1" > nul  
if %errorlevel% equ 0 (
  echo Windows 7 detectado
  goto :Seven
)
  
ver | find "6.2" > nul
if %errorlevel% equ 0 (
  echo Windows 8 detectado
  goto :Eight  
)

ver | find "6.3" > nul
if %errorlevel% equ 0 (
  echo Windows 8.1 detectado
  goto :EightOne
)
 
ver | find "10.0" > nul  
if %errorlevel% equ 0 (
  color 0B
  echo Windows 10 detectado
  goto :Ten  
)

:: Por defecto asumimos Windows 11 
color 0C
echo Windows 11 detectado
goto :Eleven


:XP
REM Comandos para XP
msg * "Mantenimiento completado en Windows XP" 
goto :EOF

:Vista  
REM Comandos para Vista
msg * "Mantenimiento completado en Windows Vista"
goto :EOF

:Seven
REM Comandos para Windows 7  
del /s /q /f %temp%\*  
rmdir /s /q %temp% 
md %temp%
cleanmgr /sagerun:1  
defrag C: /U /V
chkdsk C: /f /r /x
msg * "Mantenimiento completado en Windows 7"
goto :EOF

:Eight
REM Comandos para Windows 8
msg * "Mantenimiento completado en Windows 8"  
goto :EOF

:EightOne
REM Comandos para Windows 8.1
msg * "Mantenimiento completado en Windows 8.1"
goto :EOF
   
:Ten
REM Comandos para Windows 10
del /s /q /f %temp%\* 
rmdir /s /q %temp%  
md %temp%  
cleanmgr /sagerun:1   
defrag C: /U /V  
chkdsk C: /f /r /x
msg %username% /time:30 "Mantenimiento completado en Windows 10"
goto :EOF  

:Eleven 
REM Comandos para Windows 11
del /s /q /f %temp%\*   
rmdir /s /q %temp%
md %temp%   
cleanmgr /sagerun:1  
defrag C: /U /V    
chkdsk C: /f /r /x
msg %username% /time:30 "Mantenimiento completado en Windows 11" 
goto :EOF