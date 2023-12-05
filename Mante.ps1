# Este script crea una interfaz gráfica completa para realizar mantenimiento a Windows 10 o 11.

# Importa los módulos necesarios.
Import-Module ISE
Import-Module Microsoft.VisualBasic.PowerPacks

# Crea un nuevo formulario.
$form = New-Form -WindowTitle "Mantenimiento de Windows"

# Crea pestañas para las diferentes herramientas de mantenimiento.
$pestañaAnalizar = $form.TabControl.Controls.AddTab("Analizar")
$pestañaLimpiar = $form.TabControl.Controls.AddTab("Limpiar")
$pestañaOptimizar = $form.TabControl.Controls.AddTab("Optimizar")
$pestañaActualizar = $form.TabControl.Controls.AddTab("Actualizar")

# Crea botones para todas las herramientas de mantenimiento.
# Pestaña Analizar
$botonAnalizarSistema = $pestañaAnalizar.Controls.AddButton("Analizar el sistema")
$botonRepararArchivos = $pestañaAnalizar.Controls.AddButton("Reparar archivos dañados")

# Pestaña Limpiar
$botonLimpiarDiscoDuro = $pestañaLimpiar.Controls.AddButton("Limpiar el disco duro")
$botonLiberarEspacio = $pestañaLimpiar.Controls.AddButton("Liberar espacio en el disco duro")

# Pestaña Optimizar
$botonDesfragmentarDiscoDuro = $pestañaOptimizar.Controls.AddButton("Desfragmentar el disco duro")
$botonAjustarConfiguración = $pestañaOptimizar.Controls.AddButton("Ajustar la configuración del sistema")

# Pestaña Actualizar
$botonInstalarActualizaciones = $pestañaActualizar.Controls.AddButton("Instalar actualizaciones")
$botonVerificarEstado = $pestañaActualizar.Controls.AddButton("Verificar el estado de las actualizaciones")

# Crea el objeto lista.
$lista = New-Object System.Windows.Forms.ListBox

# Agrega los comandos de mantenimiento a los botones.
$botonAnalizarSistema.Add_Click({$lista.SelectedItem | & "sfc /scannow"})
$botonRepararArchivos.Add_Click({$lista.SelectedItem | & "sfc /scannow"})
$botonLimpiarDiscoDuro.Add_Click({$lista.SelectedItem | & "cleanmgr"})
$botonLiberarEspacio.Add_Click({$lista.SelectedItem | & "cleanmgr"})
$botonDesfragmentarDiscoDuro.Add_Click({$lista.SelectedItem | & "defrag"})
$botonAjustarConfiguración.Add_Click({$lista.SelectedItem | & "sysdm.cpl"})
$botonInstalarActualizaciones.Add_Click({$lista.SelectedItem | & "wuauclt /updatenow"})
$botonVerificarEstado.Add_Click({$lista.SelectedItem | & "wuauclt /checknow"})


# Muestra el formulario.
$form.ShowDialog()
