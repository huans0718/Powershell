# Remote Check IIS
$C=@('whdcepweb51.aprdmz.com','whdcepweb52.aprdmz.com')
Function get-iisinfo ($computer)
{
Invoke-Command -ComputerName $computer -scriptblock {c:\windows\system32\inetsrv\appcmd.exe list apppool} 
Write-Host $computer
}

foreach ($Server in $C)
{
get-iisinfo $Server
}
