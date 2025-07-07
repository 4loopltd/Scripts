# Enable required services
$services = @("fdPHost", "FDResPub", "SSDPSRV", "upnphost", "lmhosts")
foreach ($svc in $services) {
    Set-Service -Name $svc -StartupType Manual -ErrorAction SilentlyContinue
    Start-Service -Name $svc -ErrorAction SilentlyContinue
}

# Enable firewall rules for Network Discovery and File Sharing (Private only)
Get-NetFirewallRule -DisplayGroup "Network Discovery" | Where-Object { $_.Profile -match "Private" } | Enable-NetFirewallRule
Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" | Where-Object { $_.Profile -match "Private" } | Enable-NetFirewallRule

Write-Host "NAS discovery enabled. You should now see your NAS in File Explorer." -ForegroundColor Green