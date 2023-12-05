@echo off
title Herramienta Completa de Mantenimiento

powershell.exe -noexit -c "& {
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Ejecutar-Acciones {
    $accionesSeleccionadas = $listbox.CheckedItems

    foreach ($accion in $accionesSeleccionadas) {
        # Agrega lógica para ejecutar cada acción seleccionada
        Write-Host 'Ejecutando acción:' $accion
    }
}

$form = New-Object Windows.Forms.Form 
$form.Size = '500,500'
$form.Text = 'Herramienta Completa de Mantenimiento'

$listbox = New-Object Windows.Forms.CheckedListBox
$listbox.Location = '20,50'
$listbox.Size = '180,280'
$listbox.CheckOnClick = $true

$listbox.Items.Add('Limpiar archivos temporales', 0)
$listbox.Items.Add('Limpiar Caché de DNS', 0)  
$listbox.Items.Add('Limpiar errores de sistema', 0)
$listbox.Items.Add('Desactivar inicio de Apps innecesarias', 0)
$listbox.Items.Add('Desfragmentar disco', 0)  
$listbox.Items.Add('Eliminar archivos innecesarios', 0)
$listbox.Items.Add('Detectar archivos dañados', 0)
$listbox.Items.Add('Chequear errores en Disco', 0)
$listbox.Items.Add('Liberar memoria caché', 0)
$listbox.Items.Add('Optimizar tiempo de inicio', 0)
$listbox.Items.Add('Analizar consumo de recursos', 0)

$button = New-Object Windows.Forms.Button
$button.Text = "Ejecutar"
$button.Location = '250,230'  
$button.Add_Click({
    Ejecutar-Acciones
}) 

$form.Controls.Add($listbox)
$form.Controls.Add($button)
$form.Topmost = $true 

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
}";
