@echo off
chcp 65001 > nul
REM Lista de mensajes graciosos
setlocal enabledelayedexpansion
set mensajes[0]=¿Por qué los pájaros no usan Facebook? Porque ya tienen Twitter.
set mensajes[1]=¿Qué le dice un jardinero a otro jardinero? Nos vemos cuando podamos.
set mensajes[2]=¿Por qué el libro de matemáticas se suicidó? Porque tenía demasiados problemas.
set mensajes[3]=¿Qué hace una abeja en el gimnasio? ¡Zum-ba!
set mensajes[4]=¿Cómo se llama el campeón de buceo japonés? Tokofondo.
set mensajes[5]=¿Qué le dijo una iguana a su hermana gemela? Somos iguanitas.
set mensajes[6]=¿Cómo se despiden los químicos? Ácido un placer.

REM Crear múltiples ventanas de CMD y mostrar mensajes en ellas
for /l %%i in (1, 1, 30) do (
    start cmd /k "echo !mensajes[%%i]!"
)
