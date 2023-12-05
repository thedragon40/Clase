# MantenimientoPC.ps1

# Configuración de la codificación para mostrar caracteres especiales
$OutputEncoding = [System.Text.Encoding]::UTF8

# Cargar la Asamblea para Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Función para crear y mostrar la interfaz gráfica
function Mostrar-Interfaz {
    $form = New-Object Windows.Forms.Form
    $form.Text = "Mantenimiento de PC"
    $form.Width = 400
    $form.Height = 300
    $form.StartPosition = "CenterScreen"

    $listBox = New-Object Windows.Forms.ListBox
    $listBox.Location = New-Object Drawing.Point(10, 10)
    $listBox.Size = New-Object Drawing.Size(120, 200)
    $form.Controls.Add($listBox)

    $buttonEjecutar = New-Object Windows.Forms.Button
    $buttonEjecutar.Location = New-Object Drawing.Point(150, 10)
    $buttonEjecutar.Size = New-Object Drawing.Size(200, 30)
    $buttonEjecutar.Text = "Ejecutar"
    $buttonEjecutar.Add_Click({
        $opciones = $listBox.SelectedItems
        Ejecutar-Opciones $opciones
    })
    $form.Controls.Add($buttonEjecutar)

    $buttonSalir = New-Object Windows.Forms.Button
    $buttonSalir.Location = New-Object Drawing.Point(150, 50)
    $buttonSalir.Size = New-Object Drawing.Size(200, 30)
    $buttonSalir.Text = "Salir"
    $buttonSalir.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($buttonSalir)

    # Agregar opciones al ListBox
    $opcionesMenu = @(
        "Desfragmentar el disco",
        "Limpiar archivos temporales",
        "Verificar y reparar errores en el disco",
        "Actualizar el sistema",
        "Escanear seguridad con Windows Defender",
        "Liberar espacio en disco",
        "Respaldar archivos importantes",
        "Crear un punto de restauración del sistema",
        "Desinstalar aplicaciones no deseadas",
        "Gestionar programas de inicio del sistema",
        "Ejecutar todas las opciones",
        "Salir"
    )

    $listBox.Items.AddRange($opcionesMenu)

    $form.ShowDialog()
}

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

# Función para liberar espacio en disco
function Liberar-Espacio {
    Write-Host "Liberando espacio en disco..."
    Cleanmgr /sagerun:1  # Ejecuta la Limpieza de disco con la configuración predefinida
    Compact /CompactOs:always  # Comprime archivos del sistema
}

# Función para respaldar archivos importantes
function Respaldar-Archivos {
    Write-Host "Respaldando archivos importantes..."
    # Agrega aquí los comandos o la lógica para respaldar archivos
}

# Función para crear un punto de restauración del sistema
function Crear-Punto-Restauracion {
    Write-Host "Creando un punto de restauración del sistema..."
    Checkpoint-Computer -Description "Punto de restauración antes de mantenimiento" -RestorePointType MODIFY_SETTINGS
}

# Función para desinstalar aplicaciones no deseadas
function Desinstalar-Aplicaciones {
    Write-Host "Desinstalando aplicaciones no deseadas..."
    # Agrega aquí los comandos o la lógica para desinstalar aplicaciones
}

# Función para gestionar programas de inicio del sistema
function Gestionar-Inicio-Sistema {
    Write-Host "Optimizando programas de inicio del sistema..."
    # Agrega aquí los comandos o la lógica para gestionar el inicio del sistema
}

# Función para ejecutar las opciones seleccionadas
function Ejecutar-Opciones($opciones) {
    foreach ($opcion in $opciones) {
        switch ($opcion) {
            "Desfragmentar el disco" { Desfragmentar-Disco }
            "Limpiar archivos temporales" { Limpiar-Temporales }
            "Verificar y reparar errores en el disco" { Verificar-Errores-Disco }
            "Actualizar el sistema" { Actualizar-Sistema }
            "Escanear seguridad con Windows Defender" { Escanear-Seguridad }
            "Liberar espacio en disco" { Liberar-Espacio }
            "Respaldar archivos importantes" { Respaldar-Archivos }
            "Crear un punto de restauración del sistema" { Crear-Punto-Restauracion }
            "Desinstalar aplicaciones no deseadas" { Desinstalar-Aplicaciones }
            "Gestionar programas de inicio del sistema" { Gestionar-Inicio-Sistema }
            "Ejecutar todas las opciones" {
                Desfragmentar-Disco; Limpiar-Temporales; Verificar-Errores-Disco;
                Actualizar-Sistema; Escanear-Seguridad; Liberar-Espacio; Respaldar-Archivos;
                Crear-Punto-Restauracion; Desinstalar-Aplicaciones; Gestionar-Inicio-Sistema
            }
            "Salir" { $form.Close() }
            default { Write-Host "Opción no válida: $opcion" }
        }
    }
}

# Ejecución del programa
Mostrar-Interfaz
