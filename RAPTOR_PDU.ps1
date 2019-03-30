<#
.SYNOPSIS
    Name: RAPTOR_PDU.ps1
    The purpose of this script is to take data from Raptor website
.DESCRIPTION
    Created for my team.
.NOTES
    Version:        0.07
	Updated			27.03.2019
    Creation Date:  17.03.2019
    File Name  : RAPTOR_PDU.ps1
    Author     : Air Dorzhukai
#>

#Variables Data
###############
#Variables for Directory and file names
$CurrentDate = Get-Date
$CurrentLongDate = $CurrentDate.ToString('dd-MM-yyyy_HH-mm')
$CurrentShortDate = $CurrentDate.ToString('MM-yyyy')
$SourceDir = "C:\RAPTOR"
$DestDir = $SourceDir + '\' + $CurrentShortDate
#URLS
$URL205 = "http://raptor.website.com/api/getRoomInfoSummary?&idc=RU66&room=A2-205.RU66"
$URL305 = "http://raptor.website.com/api/getRoomInfoSummary?&idc=RU66&room=A3-305.RU66"
$ALLURL = $URL205,$URL305
#For calculate 
$factor = [Math]::Pow(10,2)
#Create cookie and session for Raptor
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie 
#Cookie die every time when you connect to VPN or every 12 hours.
$cookie.Name = "koa:sess"
#Add your cookie to file before start script
$cookie.Value = Get-Content $($SourceDir + '\' + 'cookie' + '.txt')
$cookie.Domain = "website.com"
$session.Cookies.Add($cookie);
###############

###############
foreach ($URL in $ALLURL) {
    ###############
    #Take data from json
    $request = Invoke-RestMethod -Uri $URL -Method Get -WebSession $session -Headers  @{"accept"="application/json"}
		#Take All content
		$content = $request.data
		#Take only Name and Power
		$contentRack = $content.colList.cabList | Select-Object cabinetName, @{
			n="powerValue";
			e={	
				[Math]::Truncate($_.powerValue * 0.001 * $factor) / $factor;
			}
		} 
		#Check Directory and create if not exist
		if (!(Test-Path ($DestDir))) {
				New-Item ($DestDir) -type directory
			}
		#Create File
		$contentRack | Out-File $($DestDir + '\' + $CurrentlongDate + '_' + $content.room +'.txt')
}
