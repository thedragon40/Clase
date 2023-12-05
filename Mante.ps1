# Define maintenance options and their corresponding commands
$options = @{
    "Update System" = "Update-Windows";
    "Clean Up Windows Temp Files" = "Remove-Item $env:TEMP\* -Recurse";
    "Defragment Hard Drives" = "Optimize-Volume -DriveLetter C";
    "Scan for and repair errors on hard drives" = "chkdsk C: /F";
    "Check Disk for Defects" = "chkdsk";
    "Perform System File Check" = "sfc /scannow";
    "Remove Previous Windows Installation Files" = "Remove-Item $env:SystemRoot\SoftwareDistribution\Download\* -Recurse";
}

# Create a form to display the options
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 10/11 Maintenance"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"

# Create a list box to display the options
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,20)
$listBox.Size = New-Object System.Drawing.Size(260,120)
$listBox.Height = 60

# Add options to the list box
foreach ($option in $options.Keys) {
    $listBox.Items.Add($option)
}

# Create a button to execute the selected command
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(75,150)
$button.Size = New-Object System.Drawing.Size(150,20)
$button.Text = "Run Selected Maintenance Task"

# Handle the button click event
$button.Add_Click({
    # Get the selected option and its corresponding command
    $selectedOption = $listBox.SelectedItem
    $command = $options[$selectedOption]

    # Display a confirmation message box
    $confirmation = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to run the selected maintenance task?", "Confirmation", "YesNo", "Warning")

    # If the user confirms, run the selected command
    if ($confirmation -eq "Yes") {
        Invoke-Expression $command
    }
})

# Add the list box and button to the form
$form.Controls.Add($listBox)
$form.Controls.Add($button)

# Show the form
$form.ShowDialog() | Out-Null
