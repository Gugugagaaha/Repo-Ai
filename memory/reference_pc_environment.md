---
name: setup-environment-pc-bukan-laptop
description: Struktur direktori dan symlink setup di PC user — berbeda dari laptop
metadata: 
  node_type: memory
  type: reference
  originSessionId: fd5daec4-f61b-4b01-9da5-8691f529321c
---

**PC environment (bukan laptop) — Status per 2026-05-16 (post-setup ulang):**

- `C:\Users\Administrator\.claude` → SymbolicLink ke `E:\Claude`
- Config git repo: `E:\Claude\Config` (clone dari https://github.com/Gugugagaaha/Repo-Ai, branch master)
- Symlinks aktif:
  - `~/.claude/CLAUDE.md` → `E:\Claude\Config\CLAUDE.md`
  - `~/.claude/commands` → `E:\Claude\Config\commands`
  - `~/.claude/memory` → `E:\Claude\Config\memory` (via projects/C--Users-Administrator--local-bin)
- Hook UserPromptSubmit: `E:\Claude\Config\hooks\prompt_counter.ps1`
- tiktoken installed, token_counter.py di `E:\Claude\Config\token_counter.py` — functional
- Python: 3.14.5, Git: 2.54.0, Claude: binary di `.local\bin` (tidak di PATH default)

**Drive layout:**
- `C:\` — OS (bisa di-wipe saat reinstall, .claude cuma symlink)
- `D:\claude-config` — backup lama, sudah tidak aktif, tidak ada .git
- `E:\Claude` — config aktif, aman dari reinstall C:\

**Laptop environment:**
- Config git repo: `D:\claude-config` (dengan .git aktif)
- Struktur `.claude` kemungkinan tidak pakai symlink

**Cara deteksi di script:**
```powershell
$claudeItem = Get-Item "$env:USERPROFILE\.claude" -ErrorAction SilentlyContinue
if ($claudeItem.LinkType -eq "SymbolicLink") {
    $configRepo = Join-Path $claudeItem.Target "Config"  # E:\Claude\Config
} else {
    # fallback: cek D:\claude-config, D:\CLAUDE CODE\Config
}
```
