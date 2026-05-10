---
name: history
description: Load konteks sesi sebelumnya — baca memory, PROGRESS.md (global), dan SESSION_LOG.md (3 hari terakhir) agar Claude langsung nyambung tanpa perlu dijelaskan dari awal
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

## Step 3 — Baca PROGRESS.md (Global)

PROGRESS.md sekarang **global** — selalu di `$configRepo\PROGRESS.md`, bukan per-project lagi.

```powershell
$progressGlobal = Join-Path $configRepo "PROGRESS.md"
if (Test-Path $progressGlobal) {
    Get-Content $progressGlobal -Raw
}
```

Fokus pada:
- Entry terbaru (tanggal paling recent)
- Pending / Next Steps yang belum selesai
- Keputusan penting yang masih relevan

**Fallback (legacy):** Jika ada `PROGRESS.md` di current working directory (struktur project lama), baca juga sebagai konteks tambahan — tapi treat sebagai read-only history. Update terbaru selalu masuk ke global.

---

## Step 4 — Baca SESSION_LOG.md (3 Hari Terakhir)

Baca `$configRepo\SESSION_LOG.md` — tapi filter cuma **3 hari terakhir** untuk hemat token. Entry yang lebih lama tetap ada di file (untuk audit), tinggal scroll/grep manual kalau butuh.

```powershell
$sessionLog = Join-Path $configRepo "SESSION_LOG.md"
if (Test-Path $sessionLog) {
    $content = Get-Content $sessionLog -Raw
    $cutoff = (Get-Date).AddDays(-3)

    # Split per section (## YYYY-MM-DD ...)
    $sections = $content -split '(?m)^## ' | Where-Object { $_.Trim() }

    $recent = @()
    foreach ($section in $sections) {
        # Parse tanggal dari awal section: "2026-05-09 | PC | ..." atau "2026-05-09 03:23 WIB | ..."
        if ($section -match '^(\d{4}-\d{2}-\d{2})') {
            $sectionDate = [datetime]::ParseExact($matches[1], 'yyyy-MM-dd', $null)
            if ($sectionDate -ge $cutoff) {
                $recent += "## $section"
            }
        }
    }

    if ($recent.Count -gt 0) {
        Write-Host "=== SESSION_LOG (3 hari terakhir, $($recent.Count) entry) ==="
        $recent -join "`n"
    } else {
        Write-Host "Tidak ada entry SESSION_LOG dalam 3 hari terakhir."
        Write-Host "Cek manual di $sessionLog kalau perlu konteks lebih lama."
    }
}
```

Tampilkan hasil filter ini sebagai konteks. Kalau butuh history lebih lama → user bisa buka file langsung atau grep di repo.

---

## Step 5 — Reset Prompt Counter

```powershell
Set-Content "$configRepo\prompt_counter.txt" "0"
```

---

## Step 6 — Trigger Token Counter (Estimasi Baseline)

Setelah semua konteks dimuat, hitung estimasi token yang sudah terpakai untuk loading context (memory + PROGRESS + SESSION_LOG filter). Ini jadi baseline awal sesi.

```powershell
$tokenScript = Join-Path $configRepo "token_counter.py"
if (Test-Path $tokenScript) {
    # Combine semua konten yang dimuat di /history
    $combined = ""
    $contextFiles = @(
        (Join-Path $configRepo "memory\MEMORY.md"),
        (Join-Path $configRepo "PROGRESS.md")
    )
    foreach ($f in $contextFiles) {
        if (Test-Path $f) { $combined += (Get-Content $f -Raw) + "`n" }
    }

    # SESSION_LOG sudah difilter di Step 4 — pakai hasil filter, bukan full file
    if ($recent -and $recent.Count -gt 0) {
        $combined += ($recent -join "`n")
    }

    # Pipe ke token_counter.py via stdin
    $combined | python $tokenScript
} else {
    Write-Host "[skip] token_counter.py tidak ditemukan di $tokenScript"
}
```

Output token count dimasukkan ke laporan Step 7.

---

## Step 7 — Laporan Konteks ke User

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

[PROGRESS.md (Global) — Entry Terakhir: YYYY-MM-DD HH:mm WIB]
- Topik terakhir : <ringkasan 1 kalimat>
- Next steps     : <list pending jika ada>

[SESSION_LOG — 3 Hari Terakhir (X entry)]
- <tanggal entry 1> : <topik singkat>
- <tanggal entry 2> : <topik singkat>
- dst.

[Token Baseline]
- Context loaded : ~X token (estimasi via tiktoken)
- Threshold      : 2,000 token per batch SESSION_LOG

Siap lanjut. Mau mulai dari mana?
```
