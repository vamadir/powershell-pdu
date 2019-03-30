<#
.SYNOPSIS
    Name: THRUK_PDU.ps1
    The purpose of this script is to take data from THRUK (NAGIOS) website
.DESCRIPTION
    Created for Alibaba russian team.
.NOTES
    Version:        0.01
	Updated			27.03.2019
    Creation Date:  27.03.2019
    File Name  : THRUK_PDU.ps1
    Author     : Air Dorzhukai
#>
#FIX. Allow not signed SSL certificate
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Variables Data
###############
#Variables for Directory and file names
$CurrentDate = Get-Date
$CurrentLongDate = $CurrentDate.ToString('dd-MM-yyyy_HH-mm')
$CurrentShortDate = $CurrentDate.ToString('MM-yyyy')
$SourceDir = "C:\THRUK_PDU\"
$PDUDir = $($SourceDir +'PDU' + '\' + $CurrentShortDate)
#Password and user
$user = "username"
$pass = "userpassword"
$securepasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user, $securepasswd)

#Basic request
$request = Invoke-WebRequest -Uri "https://somewebsite.com/thruk/cgi-bin/status.cgi?view_mode=json&service=all&columns=display_name,host_name,perf_data" -Credential $cred -Headers  @{"accept"="application/json"}
$content = $request.Content | ConvertFrom-Json
#######################

#######################
$PDUs = $content -match "PDU" 
$PDUData = $PDUs | Where-Object -Match -Property display_name -Value ("Active Power") | Select-Object host_name,@{
    n="kW"
    e={
        [regex]::Matches($_.perf_data, '(?<=rta.)\d+.\d+') ;
    }
}
#Find hall what we need, My 6H8&6H4
$6H4PDU = $PDUData -match"6H4"
$6H8PDU = $PDUData -match"6H8"
#Check Directory and create if not exist
if (!(Test-Path ($PDUDir))) {
    New-Item ($PDUDir) -type directory
}
#Create File
$6H4PDU | Out-File $($PDUDir + '\' + $CurrentlongDate + '_6H4PDU' + '.txt') 
$6H8PDU | Out-File $($PDUDir + '\' + $CurrentlongDate + '_6H8PDU' +'.txt') 
