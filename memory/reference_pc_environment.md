---
name: setup-environment-pc-bukan-laptop
description: Struktur direktori dan symlink setup di PC user — berbeda dari laptop
metadata: 
  node_type: memory
  type: reference
  originSessionId: fd5daec4-f61b-4b01-9da5-8691f529321c
---

**PC environment (bukan laptop) — Status per 2026-07-20 (post Windows reinstall, superseded entry di bawah):**

- Windows di-reinstall total setelah incident infostealer 2026-05-16 (lihat SESSION_LOG 2026-05-16). Username lama `Administrator` sudah tidak dipakai lagi — user sekarang pakai akun `Enzu` (sesuai rekomendasi pre-reinstall: jangan pakai built-in Administrator).
- `C:\Users\Enzu\.claude` — folder **biasa** (bukan symlink), tapi isinya per-item symlink:
  - `~/.claude/CLAUDE.md` → `D:\Claude\Config\CLAUDE.md`
  - `~/.claude/commands` → `D:\Claude\Config\commands`
  - `~/.claude/projects\C--Users-Enzu--local-bin\memory` → `D:\Claude\Config\memory`
  - `~/.claude/skills\notion-design` → `D:\Claude\Config\custom-skills\notion-design`
- Config git repo: `D:\Claude\Config` (clone dari https://github.com/Gugugagaaha/Repo-Ai, branch master) — bukan `E:\Claude\Config` lagi, drive `E:` sudah tidak dipakai di setup baru ini.
- Hook UserPromptSubmit: `D:\Claude\Config\hooks\prompt_counter.ps1`, terdaftar di `~/.claude/settings.json` (file biasa, bukan symlink — di-generate/merge oleh `setup.ps1`).
- Project path encoding: `C--Users-Enzu--local-bin` (cwd kerja utama: `C:\Users\Enzu\.local\bin`).
- Saat setup ulang di sesi ini (2026-07-20), `setup.ps1` sempat belum pernah dijalankan di device baru ini — `CLAUDE.md`/`commands`/`memory`/`settings.json` semua kosong sampai dijalankan manual. Ketemu juga bug: candidate path auto-detect di `hooks/prompt_counter.ps1` + `commands/up.md,history.md,updateskills.md` gak include path baru `D:\Claude\Config` → sudah di-fix (lihat SESSION_LOG 2026-07-20).

**Drive layout (per 2026-07-20):**
- `C:\` — OS (bisa di-wipe saat reinstall, `.claude` isinya cuma symlink/pointer ke D:, aman)
- `D:\Claude\Config` — config aktif sekarang
- `E:\Claude` — **sudah tidak ada/tidak dipakai** (entry lama di bawah basi, drive letter berubah pasca reinstall)

**Laptop environment (belum diverifikasi ulang sejak reinstall PC ini, kemungkinan masih valid):**
- Config git repo: `D:\claude-config` (dengan .git aktif)
- Struktur `.claude` kemungkinan tidak pakai symlink

**Cara deteksi di script (updated — self-detecting, gak perlu update manual tiap ganti drive/device):**
```powershell
$commandsItem = Get-Item "$env:USERPROFILE\.claude\commands" -ErrorAction SilentlyContinue
$claudeItem = Get-Item "$env:USERPROFILE\.claude" -ErrorAction SilentlyContinue
$candidates = @()
if ($commandsItem.LinkType -eq "SymbolicLink") {
    $candidates += Split-Path $commandsItem.Target -Parent   # self-detect, selalu akurat post-setup
}
if ($claudeItem.LinkType -eq "SymbolicLink") {
    $candidates += Join-Path $claudeItem.Target "Config"
}
$candidates += "D:\Claude\Config", "D:\CLAUDE CODE\Config", "D:\claude-config", "$env:USERPROFILE\.claude\Config"
$configRepo = $candidates | Where-Object { $_ -and (Test-Path "$_\.git") } | Select-Object -First 1
```

**Lesson learned:** tiap kali ganti device/reinstall/pindah drive, entry "status per tanggal X" di memory ini jadi basi cepat. Entry lama TIDAK dihapus (audit trail), tapi selalu tandai entry mana yang superseded dan cek ulang sebelum dipakai sebagai asumsi.

---

**Gotcha PATH di PC ini (ditemukan 2026-07-20, sudah di-fix, dicatat untuk referensi debugging):**

`npm run dev` sempat gagal total tanpa error message (proses exit instan, prompt langsung balik) karena 2 masalah bertumpuk:
1. File kosong (0 byte) `C:\WINDOWS\system32\npm` (tanpa extension) — kebuat gak sengaja pas setup environment awal (19 Juli), shadow `npm.cmd` asli di `C:\Program Files\nodejs\` karena System32 lebih dulu di PATH. Sudah dihapus.
2. PowerShell Execution Policy `Restricted` (default Windows) blokir `npm.ps1` — fix: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` (gak butuh admin).

**Teknik debug yang kepake (reusable buat kasus serupa "command CLI silently fail/gak ada output" di Windows):**
```powershell
Get-Command <nama-command> -All | Format-List Name, CommandType, Source   # cek SEMUA match di PATH, urutan prioritas
($env:PATH -split ';') | Select-String -Pattern "<keyword>"                # cek urutan PATH
Get-ExecutionPolicy -List                                                   # cek semua scope policy
```
