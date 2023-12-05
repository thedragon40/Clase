# Script de mantenimiento de Windows

# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal]::GetCurrent().IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "Este script debe ejecutarse con privilegios de administrador."
    exit
}

# Declarar variables
$selectedFunctions = ""

# Mostrar lista de funciones 
Write-Host "Funciones disponibles:"
Write-Host "1. Actualizar Windows"
Write-Host "2. Buscar y eliminar virus y malware"
Write-Host "3. Liberar espacio en disco"
Write-Host "4. Optimizar el registro de Windows"
Write-Host "5. Desfragmentar el disco duro"
Write-Host "6. Reparar archivos de sistema"
Write-Host "7. Eliminar archivos temporales"
Write-Host "8. Desinstalar programas no deseados"
Write-Host "9. Reiniciar el sistema"

# Leer la selección del usuario
Write-Host "Escribe los números de las funciones que deseas ejecutar (separadas por espacios): "
$selectedFunctions = Read-Host

# Validar selección 
if ($selectedFunctions -eq "") {
    Write-Host "Error: Selecciona al menos una función."
    exit
}

# Ejecutar las funciones seleccionadas
$selectedFunctionsArray = $selectedFunctions.Split(" ")
foreach ($function in $selectedFunctionsArray) {
    switch ($function) {
        case"1": 
            {
                Write-Host "Actualizando Windows..."
                Start-Process "wuauclt.exe" -ArgumentList "/updatenow"
            }
            break
        case"2":
            {
                Write-Host "Buscando y eliminando virus y malware..." 
                Start-Process "msconfig.exe" -ArgumentList "/scannow"
            }
            break
        case"3":
            {
                Write-Host "Liberando espacio en disco..."
                Start-Process "cleanmgr.exe" -ArgumentList "/sageset:65535 /d %windir%\System32\config\systemprofile\AppData\Local\Temp /d %windir%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\Temporary Internet Files /d %windir%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\SoftwareDistribution\Download"
            }
            break
        case"4":
            {
                Write-Host "Optimizando el registro de Windows..."
                Start-Process "regedit.exe" -ArgumentList "/s %~dp0\optimize_registry.reg"
            }
            break
        case"5":
            {
                Write-Host "Desfragmentando el disco duro..." 
                Start-Process "dfrg.msc"
            }
            break
        case"6":
            {
                Write-Host "Reparando archivos de sistema..."
                Start-Process "sfc.exe" -ArgumentList "/scannow"
            }
            break
        case"7":
            {
                Write-Host "Eliminando archivos temporales..."
                Start-Process "cmd.exe" -ArgumentList "/c del /q /f %windir%\Temp\*"  
            }
            break
        case"8":
            {
                Write-Host "Desinstalando programas no deseados..."
                Start-Process "appwiz.cpl"
            }
            break
        case"9": 
            {
                Write-Host "Reiniciando el sistema..."
                Start-Process "shutdown.exe" -ArgumentList "/r /t 0"
            }
            break
        default:
            Write-Host "Función no válida."
    }
}
