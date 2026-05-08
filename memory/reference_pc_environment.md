---
name: Setup environment PC (bukan laptop)
description: Struktur direktori dan symlink setup di PC user — berbeda dari laptop
type: reference
---

**PC environment (bukan laptop):**

- `C:\Users\Administrator\.claude` → symlink ke `D:\CLAUDE CODE`
- Config git repo: `D:\CLAUDE CODE\Config` (bukan `D:\claude-config` seperti di laptop)
- Claude binary: `D:\CLAUDE CODE\app\claude.exe`
- `C:\Users\Administrator\.local\bin\claude.exe` → symlink ke `D:\CLAUDE CODE\app\claude.exe` (dibuat untuk fix installMethod native check)
- Claude Code versi: 2.1.133
- `installMethod: "native"` di `C:\Users\Administrator\.claude.json`

**Laptop environment:**
- Config git repo: `D:\claude-config`
- Struktur `.claude` kemungkinan tidak pakai symlink

**Cara deteksi di script:**
```powershell
$claudeItem = Get-Item "$env:USERPROFILE\.claude" -ErrorAction SilentlyContinue
if ($claudeItem.LinkType -eq "SymbolicLink") {
    $configRepo = Join-Path $claudeItem.Target "Config"
} else {
    # fallback: cek kandidat path lain
}
```
