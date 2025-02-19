This repo is for powershell

## USAGE

To use this repo, run the connect_and_transfer.ps1 script in order to connect to a remote computer. The script will ask for remoteIP, credentials, local directory and destination directory. 
Once these are filled out, it will transfer the addusers.ps1 script and users.csv file to the remote computer.
If the transfer succeeds, the script will ask to proceed, and if you enter "Y", it will execute the addusers.ps1 script, and start adding the users to the domain. 
Once the addusers script is done, it will terminate the PSSession. 

## Credits: 

Made by me...

