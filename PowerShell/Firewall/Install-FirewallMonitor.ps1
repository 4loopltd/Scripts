# === CONFIGURATION ===
$monitorScriptPath = "$env:ProgramData\FirewallRuleMonitor\Monitor-InboundFirewallChanges.ps1"
$baselinePath = "$env:ProgramData\FirewallRuleMonitor\inbound-baseline.json"
$logPath = "$env:ProgramData\FirewallRuleMonitor\inbound-changes.log"
$taskName = "MonitorFirewallRules"

# === Create working directory ===
New-Item -Path (Split-Path $monitorScriptPath) -ItemType Directory -Force | Out-Null

# === Write the monitor script ===
@'
Add-Type -AssemblyName System.Windows.Forms

$baselinePath = "$env:ProgramData\FirewallRuleMonitor\inbound-baseline.json"
$logPath = "$env:ProgramData\FirewallRuleMonitor\inbound-changes.log"
$checkIntervalMinutes = 10

function Get-InboundRuleSnapshot {
    Get-NetFirewallRule -Direction Inbound | Where-Object { $_.Enabled -eq "True" } |
    Select-Object Name, DisplayName, Profile, Action, Program, LocalPort, Protocol
}

function Save-Snapshot {
    param ($snapshot)
    $snapshot | ConvertTo-Json -Depth 4 | Set-Content -Path $baselinePath -Encoding UTF8
}

function Load-Snapshot {
    if (Test-Path $baselinePath) {
        Get-Content $baselinePath -Raw | ConvertFrom-Json
    } else {
        @()
    }
}

function Compare-Snapshots {
    param ($old, $new)
    $oldNames = $old | ForEach-Object { $_.Name }
    $new | Where-Object { $oldNames -notcontains $_.Name }
}

function Alert-NewRules {
    param ($newRules)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    foreach ($rule in $newRules) {
        $msg = "$timestamp - New inbound rule detected: $($rule.DisplayName) [$($rule.Name)]"
        Add-Content -Path $logPath -Value $msg
        [System.Windows.Forms.MessageBox]::Show($msg, "Firewall Alert", 'OK', 'Warning')
    }
}

if (-not (Test-Path $baselinePath)) {
    $initial = Get-InboundRuleSnapshot
    Save-Snapshot -snapshot $initial
    exit
}

while ($true) {
    $baseline = Load-Snapshot
    $current = Get-InboundRuleSnapshot
    $newRules = Compare-Snapshots -old $baseline -new $current

    if ($newRules.Count -gt 0) {
        Alert-NewRules -newRules $newRules
        Save-Snapshot -snapshot $current
    }

    Start-Sleep -Seconds ($checkIntervalMinutes * 60)
}
'@ | Set-Content -Path $monitorScriptPath -Encoding UTF8

# === Register Scheduled Task ===
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$monitorScriptPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force

Write-Host "Firewall Rule Monitor installed and scheduled to run at login."
Write-Host "Log file: $logPath"
Write-Host "To uninstall, run: Uninstall-FirewallMonitor.ps1"