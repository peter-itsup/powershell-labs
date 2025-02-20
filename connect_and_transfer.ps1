$remoteIP = Read-Host "Enter IP address of remote computer: "
Write-Host "Enter the credentials"
$credentials = Get-Credential

# Make sure the remote machine has the following enabeled: 
# Enable-PSRemoting -Force

# Start the session and store path variables
$Server01SESH = New-PSSession -ComputerName $remoteIP -Credential $credentials
$source_path = Read-Host "Enter local path for directory with .csv file and .ps1 script: "
$desitnation_path = Read-Host "Enter desitnation path on remote computer: "

# Enter the session
Enter-PSSession $Server01SESH
try {
  # Copy the files to the remote computer in the given directory
  Copy-Item "$source_path/addusers.ps1" -Destination "$desitnation_path/addusers.ps1" -ToSession $Server01SESH
  Copy-Item "$source_path/users.csv" -Destination "$desitnation_path/users.csv" -ToSession $Server01SESH
  Write-Host "Files transferred successfully!"
}
catch {
  # If the transfer fails, print out the error data and quit
  Write-Host "Transfer failed"
  $error_data = $_
  Write-Host $error_data
  Exit
}

$answer = Read-Host "Transfer complete. Do you want to proceed? [y/n]"
if ("$answer" -eq "y") {
  # This simply executes the addusers scipt
  .\addusers.ps1
} else {
  Write-Host "Exiting..."
  Exit
}


# Exit connection to remote computer
Exit-PSSession
Remove-PSSession -Session $Server01SESH
