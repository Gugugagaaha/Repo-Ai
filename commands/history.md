---
name: history
description: Load konteks sesi sebelumnya — baca memory, PROGRESS.md, dan SESSION_LOG.md agar Claude langsung nyambung tanpa perlu dijelaskan dari awal
---

Jalankan ini di awal sesi baru untuk restore konteks. Ikuti langkah berikut secara berurutan.

---

## Step 0 — Deteksi Config Repo Path

```powershell
$claudeItem = Get-Item "$env:USERPROFILE\.claude" -ErrorAction SilentlyContinue
$candidates = @()
if ($claudeItem.LinkType -eq "SymbolicLink") {
    $candidates += Join-Path $claudeItem.Target "Config"
}
$candidates += "D:\CLAUDE CODE\Config", "D:\claude-config", "$env:USERPROFILE\.claude\Config"
$configRepo = $candidates | Where-Object { $_ -and (Test-Path "$_\.git") } | Select-Object -First 1
if (-not $configRepo) { Write-Error "Config repo tidak ditemukan!"; exit 1 }
Write-Host "Config repo ditemukan: $configRepo"
```

---

## Step 1 — Pull Latest dari GitHub

Pastikan semua file konteks adalah yang terbaru:

```powershell
cd $configRepo
git pull
```

---

## Step 2 — Baca MEMORY.md (Rules & Context)

Baca file `$configRepo\memory\MEMORY.md` — ini index semua memory yang relevan.

Untuk setiap entry di MEMORY.md yang relevan dengan project/sesi saat ini, baca file memory-nya juga. Prioritaskan:
- Semua `feedback_*.md` — rules perilaku gw
- `user_*.md` — profil user
- `project_*.md` — konteks project aktif
- `reference_*.md` — referensi eksternal

---

## Step 3 — Baca PROGRESS.md

Baca `PROGRESS.md` di direktori project saat ini (bukan di config repo). Fokus pada:
- Entry terbaru (tanggal paling recent)
- Pending / Next Steps yang belum selesai
- Keputusan penting yang masih relevan

Jika `PROGRESS.md` tidak ada di direktori saat ini → skip, laporkan ke user.

---

## Step 4 — Baca SESSION_LOG.md (2 Entry Terakhir)

Baca `$configRepo\SESSION_LOG.md`. Tampilkan **2 entry terakhir** saja — ini yang paling relevan untuk melanjutkan sesi.

---

## Step 5 — Reset Prompt Counter

```powershell
Set-Content "$configRepo\prompt_counter.txt" "0"
```

---

## Step 6 — Laporan Konteks ke User

Sampaikan ringkasan konteks dalam format ini:

```
/history selesai — konteks sesi dipulihkan:

[Perangkat & Config]
- Config repo : <path>
- Pull status : up to date / X commit pulled

[Memory]
- Rules aktif : X feedback rules dimuat
- User profile: <ringkasan singkat siapa user>
- Project aktif: <nama project jika ada>

[PROGRESS.md — Entry Terakhir: YYYY-MM-DD HH:mm WIB]
- Topik terakhir : <ringkasan 1 kalimat>
- Next steps     : <list pending jika ada>

[SESSION_LOG — 2 Entry Terakhir]
- <tanggal entry 1> : <topik singkat>
- <tanggal entry 2> : <topik singkat>

Siap lanjut. Mau mulai dari mana?
```
