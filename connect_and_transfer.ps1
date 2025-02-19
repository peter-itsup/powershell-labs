$remoteIP = Read-Host "Enter IP address of remote computer: "
Write-Host "Enter the credentials"
$credentials = Get-Credentials

# Make sure the remote machine has the following enabeled: 
# Enable-PSRemoting -Force
$Server01SESH = New-PSSession -ComputerName $remoteIP -Credential $credentials
$source_path = Read-Host "Enter local path for directory with .csv file and .ps1 script: "
$desitnation_path = Read-Host "Enter desitnation path on remote computer: "

try {
  Copy-Item "$source_path/addusers.ps1" -Destination "$desitnation_path/addusers.ps1" -ToSession $Server01SESH
  Copy-Item "$source_path/users.csv" -Destination "$desitnation_path/users.csv" -ToSession $Server01SESH
  Write-Host "Files transferred successfully!"
}
catch {
  Write-Host "Transfer failed"
  $error_data = $_
  Write-Host $error_data
  Exit
}

$answer = Read-Host "Transfer complete. Do you want to proceed? [y/n]"
if ("$answer" -eq "y") {
  .\addusers.ps1
} else {
  Write-Host "Exiting..."
  Exit
}


# Exit connection to remote computer
Exit-PSSession
Remove-PSSession -Session $Server01SESH
