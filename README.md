# powershell-scripts
My powershell scripts. Was created at work. For make my work more easy.  
# PDU_data.ps1  
Script for collect kW from APC PDU over network by snmpget. Script take IPs from file and asking PDU one by one. snmpget must be installed.
# THRUK_PDU.ps1  
Script for collect kW from APC PDU over THRUK (NAGIOS) website. This solution if we have nagios(thruk) and basic login. Problem with certificate, we ignore that at begininf of script
# RAPTOR_PDU.ps1
Script for collect kW from APC PDU over RAPTOR website. This solution if we have Raptor website system. Problem with auth at my organization VPN+CRED+CERTIFICATE and some other checks. So we manual create session and cookie.  
