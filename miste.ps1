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
    Write-Host -ForegroundColor Green "Extrayendo datos personales..." 
    Start-Sleep -Seconds 2
    Write-Host -ForegroundColor Green "Injectando virus..."
    Start-Sleep -Seconds 2
    Write-Host -ForegroundColor Green "Enviando datos a servidor remoto..."
    Start-Sleep -Seconds 2

    Write-Host "Hackeo completado! Sus datos ahora me pertenecen!" -ForegroundColor Red

} else {

    Write-Host "Operación cancelada"

}

Write-Host "Pulsa una tecla para salir"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
