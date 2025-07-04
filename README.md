# 🔥 Firewall Rule Monitor

A lightweight PowerShell-based tool that monitors your Windows Defender Firewall for unexpected inbound rule changes. Ideal for hardened, outbound-only setups where no unsolicited inbound traffic is allowed.

---

## ✅ Features

- Monitors for new or modified inbound firewall rules
- Alerts you with a popup and logs the change
- Runs silently in the background at login
- Stores a baseline of known-good rules
- Includes a clean uninstall script

---

## 📦 Files

| File                          | Purpose                                      |
|-------------------------------|----------------------------------------------|
| `Install-FirewallMonitor.ps1` | Installs the monitor and schedules it at login |
| `Monitor-InboundFirewallChanges.ps1` | The actual monitoring script |
| `Uninstall-FirewallMonitor.ps1` | Removes the monitor and all related files |
| `inbound-baseline.json`       | Stores your initial rule snapshot |
| `inbound-changes.log`         | Logs any detected changes to inbound rules |

---

## 🚀 Installation

1. Open PowerShell as Administrator
2. Run the installer:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Install-FirewallMonitor.ps1
