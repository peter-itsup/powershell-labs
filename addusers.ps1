# Import Active Directory module
Import-Module ActiveDirectory

# Get file path
$CSVFile = Read-Host "Enter path to .csv file: "

# Import file into variable
# Lets make sure the file path was valid
# If the file path is not valid, then exit the script
if ([System.IO.File]::Exists($CSVFile)) {
    Write-Host "Importing CSV..."
    $CSV = Import-Csv -LiteralPath "$CSVFile"
} else {
    Write-Host "File path specified was not valid"
    Exit
}

try {
# Lets iterate over each line in the CSV file
  foreach($user in $CSV) {
      # Password
      $SecurePassword = ConvertTo-SecureString "$user.'Password'" -AsPlainText -Force
      # Format their username
      $Username = $user.'Username'
      # Create new user - only works when on a Domain Controller!!
      New-ADUser -Name "$($user.'FirstName') $($user.'LastName')" `
                  -GivenName $user.'FirstName' `
                  -Surname $user.'LastName' `
                  -UserPrincipalName $Username `
                  -SamAccountName $Username `
                  -Path "$($user.'OU')" `
                  -ChangePasswordAtLogon $true `
                  -AccountPassword $SecurePassword `
                  -Enabled $([System.Convert]::ToBoolean($user.Enabled))

      # Write to host that we created a new user
      Write-Host "Created $Username"
  }

  Read-Host -Prompt "Script complete... Press enter to exit."
} 
# If the srcipt fails, it will print out the error and also store in a log file
catch {
  $errorData = $_
  $currentDateTime = Get-Date 
  $logfilename = "adduserscript_ERROR_$currentDateTime.txt"
  Write-Host "An error occured: $errorData"
  Write-Host "The error has been stored in log file called $logfilename"
  $errorData | Out-File -FilePath "C:\$logfilename"
}


