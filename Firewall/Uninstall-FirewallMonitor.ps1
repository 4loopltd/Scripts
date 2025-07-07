$taskName = "MonitorFirewallRules"
$folder = "$env:ProgramData\FirewallRuleMonitor"

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Firewall Rule Monitor uninstalled."