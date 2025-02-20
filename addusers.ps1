# Import Active Directory module
Import-Module ActiveDirectory

# Import file into variable
# Lets make sure the file path was valid
# If the file path is not valid, then exit the script
if ([System.IO.File]::Exists($CSVFile)) {
    Write-Host "Importing CSV..."
    $CSV = Import-Csv -LiteralPath ".\users.csv"
} else {
    Write-Host "File path specified was not valid"
    Exit
}

# Lets iterate over each line in the CSV file
foreach($user in $CSV) {
  $userExists = Get-ADuser -Identity $user.username
  if ($userExists) {
    Write-Host "($user.username) - User already exists, skipping to next"
    continue
  }
  try {
      # Password
      $SecurePassword = ConvertTo-SecureString "$user.'Password'" -AsPlainText -Force
      # Format their username
      $Username = $user.'Username'
      # Create new user - only works when on a Domain Controller!!
      # There is an issue with users who have the same FirstName and LastName.
      # They cause an error in the AD
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
  catch {
    # If the srcipt fails, it will print out the error and also store in a log file
    $errorData = $_
    $currentDateTime = Get-Date 
    $logfilename = "adduserscript_ERROR_$currentDateTime.txt"
    Write-Host "An error occured: $errorData"
    Write-Host "The error has been stored in log file called $logfilename"
    $errorData | Out-File -FilePath "C:\$logfilename"
  }

  Write-Host "Script complete..."
} 


