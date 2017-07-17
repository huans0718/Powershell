cls
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#Computer
$computer = get-content $here\server.txt
#Account List
$Account = get-content $here\account.txt
#Logfile
#Enable below to create new folder if log file didn't exist
#New-Item $logfolder -ItemType Directory -Force | Out-Null
$logfolder = "$here\LogFiles"
$logfile = Join-Path $logfolder "Local_group_$(Get-Date -f yyyyMMdd_hhmmss).log"

Function Do-Action
{
Param
    (
    [Parameter(Mandatory=$true)]
        [ValidateSet("Add", "Remove")]
        $Action
    )
    return $Action
}
"---Add or Remove?---"
$Do = Do-Action

Function Add-DomainUserToLocalGroup ($user,$server)
{
    try
    {
        Write-host "-----$user completed $Do on $server  -----" -BackgroundColor Blue -ForegroundColor Green
        $de = [ADSI]“WinNT://$server/Administrators,group” 
        $de.psbase.Invoke(“$Do”,([ADSI]“WinNT://$user”).path)
    }
    catch [System.Exception]
    {
        $Error[0] >> $logfile
    }
}

Foreach ($A in $Account)
{
    Foreach ($C in $computer)
        {
            $fqdn = Get-WmiObject Win32_ComputerSystem -ComputerName $C | %{ if($_.PartOfDomain){"{0}.{1}" -f $_.Name,$_.Domain}else{$_.Name} }
            Add-DomainUserToLocalGroup $A $fqdn
        }
}

Function list-member ($H)
{
     try
     {
        Write-host "-----Computer $H-----" -BackgroundColor Blue
        Invoke-Command -ComputerName $H -ScriptBlock {net localgroup administrators}   
     }
     catch [System.Exception]
     {
        $Error[0] >> $logfile
     }
}

"---------------------------------------------------------------------------------------------------"
Write-host "---Error Message---" -ForegroundColor Red
if ($logfile.contains("$E") )
{
type $logfile
}
else
{
Write-host "---No Errors---" -ForegroundColor Green
}

"---------------------------------------------------------------------------------------------------"
Write-host "---Current Member in this group---" -ForegroundColor Green

Foreach ($B in $computer)
{    
     $fqdn = Get-WmiObject Win32_ComputerSystem -ComputerName $B | %{ if($_.PartOfDomain){"{0}.{1}" -f $_.Name,$_.Domain}else{$_.Name} }
     list-member $fqdn
}

Write-host "--- Press Enter to close window ---"
Read-Host
