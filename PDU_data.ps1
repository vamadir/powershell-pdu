<#
.SYNOPSIS
    Name: PDU_data.ps1
    The purpose of this script is to take killoWats data from APC PDU
.DESCRIPTION
    Created for make my work more easy
.NOTES
    Version:        0.04
	Updated			23.12.2018
    Creation Date:  31.10.2018
    File Name  : PDU_data.ps1
    Author     : Air Dorzhukai
#>

#Variables Data
###############
$CurrentDate = Get-Date
$CurrentLongDate = $CurrentDate.ToString('dd-MM-yyyy_HH-mm')
$CurrentShortDate = $CurrentDate.ToString('MM-yyyy')
$SourceDir = "C:\PDU"
$DestDir = $SourceDir + '\' + $CurrentShortDate
#PDU data
$PDUList = Get-Content 'C:\PDU\PDU_IP_list.txt'
$Community = 'ourcommunity'
$OIDLabel = '.1.3.6.1.4.1.318.1.1.26.4.3.1.5.1'
#Create object over .NET
$Output = [System.Collections.Generic.List[pscustomobject]]::New()
###############
#Begin collect data
Foreach($IPAddress in $PDUList){
	$data = snmpget -v 1 -c $Community $IPAddress $OIDLabel
	$Value = $data.Split(':')[3].Trim()
	$Object = [pscustomobject]@{
#		IPAddress = $IPAddress #For Debug
		Value = $Value
	}
	$Null = $Output.Add($Object)
}
#Check Directory and create if not exist
if (!(Test-Path ($DestDir))) {
	New-Item ($DestDir) -type directory
}
#Create File
$Output | Out-File $($DestDir + '\' + 'PDU_'+ $CurrentlongDate +'.txt')
