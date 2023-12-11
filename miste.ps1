Clear-Host

$name = Read-Host -Prompt "Introduzca su nombre"
$lastname = Read-Host -Prompt "Introduzca su apellido"  
$age = Read-Host -Prompt "Introduzca su edad"
$personaldata = Read-Host -Prompt "Introduzca algún dato personal"

$continue = Read-Host -Prompt "¿Desea continuar? (S/N)"

if ($continue -eq 'S') {

    Clear-Host

    Write-Host -ForegroundColor Green "Iniciando hackeo..."
    Start-Sleep -Seconds 2
    
    Write-Host -ForegroundColor Green "Descifrando contraseñas..."
    Start-Sleep -Seconds 1  
    
    Write-Host -ForegroundColor Green "Accediendo a cámara web..."
    Start-Sleep -Seconds 1
    
    Write-Host -ForegroundColor Green "Monitorizando llamadas telefónicas..." 
    Start-Sleep -Seconds 1

    Write-Host -ForegroundColor Green "Leyendo historial de navegación..."
    Start-Sleep -Seconds 1

    Write-Host -ForegroundColor Green "Extrayendo fotos y archivos..." 
    Start-Sleep -Seconds 2
    
    Write-Host -ForegroundColor Green "Enviando datos a servidor secreto..."
    Start-Sleep -Seconds 2

    Write-Host -ForegroundColor Red "Todos sus datos me pertenecen ahora! Muajaja!"
    
    Write-Host -ForegroundColor Red "Le estaré vigilando..." 

} else {

   Write-Host "Operación cancelada"

}

Write-Host "Pulsa una tecla para salir"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
