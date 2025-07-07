# Define essential rule patterns to keep
$essentialPatterns = @(
    "*DHCP*",
    "*ICMPv4-In*",
    "*ICMPv6-In*",
    "*Core Networking*"
)

# Disable all other inbound rules
Get-NetFirewallRule -Direction Inbound | ForEach-Object {
    $rule = $_
    $keep = $false
    foreach ($pattern in $essentialPatterns) {
        if ($rule.DisplayName -like $pattern) {
            $keep = $true
            break
        }
    }
    if (-not $keep) {
        Disable-NetFirewallRule -Name $rule.Name
    }
}