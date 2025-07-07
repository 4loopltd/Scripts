# Stop and disable services
$services = @("fdPHost", "FDResPub", "SSDPSRV", "upnphost", "lmhosts")
foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

# Disable firewall rules for Network Discovery and File Sharing
Get-NetFirewallRule -DisplayGroup "Network Discovery" | Disable-NetFirewallRule
Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" | Disable-NetFirewallRule

Write-Host "NAS discovery disabled. Your system is now in stealth mode." -ForegroundColor Yellow