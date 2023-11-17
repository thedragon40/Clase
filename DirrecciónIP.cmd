@echo off
chcp 65001 > nul

:INICIO
cls
set /p IP="Ingrese la dirección IP base: "
set /p Subredes="Ingrese el número de subredes: "

set /a BitsRed=24  
set /a Hosts=28

setlocal EnableDelayedExpansion

set /a BitsSubred=32-%BitsRed%
set /a NumHosts=2^%BitsSubred%-2

set Mascara=11111111.11111111.11111111.%BitsSubred%00000
echo Global:
echo Mascara de red: !Mascara!

set /a TotHosts=%NumHosts% * %Subredes%

if %TotHosts% GTR 254 (
  echo No hay suficientes hosts disponibles
  goto INICIO 
)

set /a IP_Inicial=IP

for /L %%i in (1,1,%Subredes%) do (

  set /a Red=IP_Inicial
  set /a Red=Red>>BitsRed
  set /a Red=Red<<BitsRed
  
  set /a Broad=Red+NumHosts
  set /a PriIP=Red+1
  set /a UltIP=Broad-1

  set /a TotIPs=NumHosts+2

  echo %%i subred:
  echo IP red:        !Red!
  echo Total equipos: !TotIPs!
  echo IP bc:         !Broad!

  set /a IP_Inicial+=NumHosts+2

)

:MENU 
set /p opc=Desea volver a calcular? [0=Si, 1=No]

if %opc%==0 goto INICIO
if %opc%==1 exit

goto MENU
