﻿cls
Function Add-DomainUserToLocalGroup 
{ 
[cmdletBinding()] 
Param( 
[Parameter(Mandatory=$True)] 
[string]$computer, 
[Parameter(Mandatory=$True)] 
[string]$group, 
[Parameter(Mandatory=$True)] 
[string]$domain, 
[Parameter(Mandatory=$True)] 
[string]$user 
) 
    $de = [ADSI]“WinNT://$computer/$Group,group” 
    $Result=$de.psbase.Invoke(“Add”,([ADSI]“WinNT://$domain/$user”).path)
    Write-Host "Success" -ForegroundColor Green
}
