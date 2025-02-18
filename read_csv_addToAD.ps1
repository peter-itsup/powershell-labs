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

# Lets iterate over each line in the CSV file
foreach($user in $CSV) {

    # Password
    $SecurePassword = ConvertTo-SecureString "$user.'Password'" -AsPlainText -Force

    # Format their username
    $Username = $user.'Username'

    # Create new user
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

    # If groups is not null... then iterate over groups (if any were specified) and add user to groups
    if ($User.'Add Groups (csv)' -ne "") {
        $User.'Add Groups (csv)'.Split(",") | ForEach {
            Add-ADGroupMember -Identity $_ -Members "$($user.'FirstName').$($user.'LastName')"
            WriteHost "Added $Username to $_ group" # Log to console
        }
    }

    # Write to host that we created the user
    Write-Host "Created user $Username with groups $($User.'Add Groups (csv)')"
}

Read-Host -Prompt "Script complete... Press enter to exit."
