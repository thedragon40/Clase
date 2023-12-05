# MantenimientoPC.ps1

# Configuración de la codificación para mostrar caracteres especiales
$OutputEncoding = [System.Text.Encoding]::UTF8

# Función para desfragmentar el disco
function Desfragmentar-Disco {
    Write-Host "Desfragmentando el disco..."
    Optimize-Volume -DriveLetter C -Defrag -Verbose
}

# Función para limpiar archivos temporales
function Limpiar-Temporales {
    Write-Host "Limpiando archivos temporales..."
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse
}

# Función para verificar y reparar errores en el disco
function Verificar-Errores-Disco {
    Write-Host "Verificando y reparando errores en el disco..."
    Repair-Volume -DriveLetter C -Verbose
}

# Función para actualizar el sistema
function Actualizar-Sistema {
    Write-Host "Actualizando el sistema..."
    Start-Process "ms-settings:windowsupdate" -Wait
}

# Función para realizar un escaneo de seguridad con Windows Defender
function Escanear-Seguridad {
    Write-Host "Realizando escaneo de seguridad con Windows Defender..."
    Start-MpScan -ScanType QuickScan
}

# Menú principal
function Mostrar-Menu {
    Clear-Host
    Write-Host "==== Menú de Mantenimiento ===="
    Write-Host "1. Desfragmentar el disco"
    Write-Host "2. Limpiar archivos temporales"
    Write-Host "3. Verificar y reparar errores en el disco"
    Write-Host "4. Actualizar el sistema"
    Write-Host "5. Escanear seguridad con Windows Defender"
    Write-Host "6. Ejecutar todas las opciones"
    Write-Host "7. Salir"
}

# Ejecución del programa
do {
    Mostrar-Menu
    $opciones = Read-Host "Ingrese los números de las opciones deseadas, separados por comas"

    foreach ($opcion in $opciones.Split(',')) {
        switch ($opcion) {
            1 { Desfragmentar-Disco }
            2 { Limpiar-Temporales }
            3 { Verificar-Errores-Disco }
            4 { Actualizar-Sistema }
            5 { Escanear-Seguridad }
            6 { Desfragmentar-Disco; Limpiar-Temporales; Verificar-Errores-Disco; Actualizar-Sistema; Escanear-Seguridad }
            7 { break }
            default { Write-Host "Opción no válida: $opcion" }
        }
    }

    $continuar = Read-Host "Presione 'q' para salir o cualquier tecla para volver al menú"
} while ($continuar -ne 'q')
