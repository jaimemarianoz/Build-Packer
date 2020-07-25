﻿<#

.FUNCTIONALITY
Enable WinRM for Packer.IO integration

.SYNOPSIS
Change log

July 25, 2020
-Initial version
-Minor edit to remove code that was generating "access denied" errors on for loop at start

.DESCRIPTION
Author oreynolds@gmail.com

.EXAMPLE
./Start-FirstSteps.ps1

.NOTES

.Link
https://github.com/getvpro/Build-Packer

#>

### Enable WinRM

write-host "Enable WinRM for integration with packer" -ForegroundColor Cyan

Enable-PSRemoting -Force
winrm quickconfig -q
winrm quickconfig -transport:http
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
netsh advfirewall firewall set rule group="Windows Remote Administration" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow
Set-Service winrm -startuptype "auto"
Restart-Service winrm

write-host "WinRM enabled. The remote packer instance should now finish the build and power off the VM in 5 seconds" -ForegroundColor Cyan
start-sleep -Seconds 5