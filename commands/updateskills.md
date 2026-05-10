---
name: updateskills
description: Sync skills dua arah — push custom skill baru ke GitHub, sync custom skill dari repo ke local, install skill baru dari registry
---

Lakukan skill sync dua arah antara perangkat ini dan GitHub repo config. Ikuti langkah-langkah berikut secara berurutan dan laporkan hasilnya.

---

## Step 0 — Deteksi Config Repo Path

**WAJIB dijalankan pertama.** Jangan hardcode path apapun.

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

$skillsDir    = "$env:USERPROFILE\.claude\skills"
$customSkills = Join-Path $configRepo "custom-skills"
$registry     = Join-Path $configRepo "skills-registry.md"
```

Simpan semua variabel ini — dipakai di seluruh step berikutnya.

---

## Step 1 — Pull Latest dari GitHub

```powershell
cd $configRepo
git fetch origin
git merge origin/master
```

Catat hasilnya: ada update baru atau sudah up-to-date.

---

## Step 2 — Sync Custom Skills: Repo → Local

Setelah pull, cek apakah ada custom skill di repo yang belum ada di `~/.claude/skills/` di perangkat ini. Ini terjadi saat custom skill dibuat di perangkat lain lalu di-push ke GitHub.

```powershell
$repoSkills = Get-ChildItem $customSkills -Directory -ErrorAction SilentlyContinue

foreach ($skill in $repoSkills) {
    $localPath  = Join-Path $skillsDir $skill.Name
    $localItem  = Get-Item $localPath -ErrorAction SilentlyContinue

    if (-not $localItem) {
        # Skill ada di repo tapi belum ada di local → buat symlink
        New-Item -ItemType SymbolicLink -Path $localPath -Target $skill.FullName
        Write-Host "Symlink dibuat: $($skill.Name)"
    } elseif ($localItem.LinkType -ne "SymbolicLink") {
        # Ada tapi bukan symlink (duplikat?) → skip, laporkan
        Write-Host "SKIP (bukan symlink): $($skill.Name) — cek manual"
    } else {
        Write-Host "Sudah ada: $($skill.Name)"
    }
}
```

Catat: berapa skill baru yang di-symlink dari repo ke local.

---

## Step 3 — Deteksi Custom Skill Baru: Local → Repo

Scan `~/.claude/skills/` untuk item yang **bukan symlink** — ini berarti skill baru yang dibuat di perangkat ini dan belum masuk ke repo.

```powershell
$newSkills = Get-ChildItem $skillsDir | Where-Object { $_.LinkType -ne "SymbolicLink" }
```

Untuk setiap item yang ditemukan:

- Jika berupa **folder** dengan file `SKILL.md` di dalamnya → custom skill baru:
  1. Copy ke `$customSkills\<nama-folder>\`
  2. Hapus folder asli: `Remove-Item "$skillsDir\<nama>" -Recurse -Force`
  3. Buat symlink: `New-Item -ItemType SymbolicLink -Path "$skillsDir\<nama>" -Target "$customSkills\<nama>"`
  4. Tambahkan entry baru di tabel **Custom Skills** dalam `$registry` — isi kolom Skill, Path di repo, dan Keterangan (tebak dari isi SKILL.md)

- Jika berupa **file .md tunggal** (bukan folder) → skill dari marketplace, abaikan

Catat: berapa skill baru yang ditemukan dan di-push ke repo.

---

## Step 4 — Install Skills dari Registry: GitHub → Local

Baca `$registry` dan ekstrak semua repo dari tabel **Manual Skills**.

Untuk setiap repo:

```powershell
$repoSlug  = "<owner>/<repo>"   # dari kolom Repo di registry
$searchDir = "<folder>"          # dari kolom "Cari / Folder" (default: "skills")
$cacheDir  = Join-Path $configRepo "skills-cache\$($repoSlug.Split('/')[1])"

# Clone pertama kali, pull jika sudah ada
if (Test-Path "$cacheDir\.git") {
    git -C $cacheDir pull --quiet
} else {
    git clone "https://github.com/$repoSlug.git" $cacheDir --depth 1 --quiet
}

# Copy skills ke ~/.claude/skills/
if (Test-Path "$cacheDir\$searchDir") {
    Copy-Item "$cacheDir\$searchDir\*" $skillsDir -Recurse -Force
}
```

Lakukan ini untuk semua repo berikut (selalu prioritaskan isi `$registry` yang aktual — list ini hanya default):
- kostja94/marketing-skills → folder `skills`
- coreyhaines31/marketingskills → folder `skills`
- AgriciDaniel/claude-seo → folder `skills`
- zubair-trabzada/geo-seo-claude-skills → folder `skills`
- nexu-io/open-design → folder `skills`
- ComposioHQ/awesome-claude-skills → subfolder `brand-build-skills`
- garrytan/gstack → folder `skills`
- garrytan/gbrain → folder `skills`
- Orchestra-Research/AI-Research-SKILLs → folder `skills`
- VoltAgent/awesome-agent-skills → folder `skills`
- Lum1104/Understand-Anything → folder `skills`

Catat: berapa file baru berhasil di-copy untuk setiap repo.

---

## Step 5 — Push Perubahan ke GitHub

```powershell
cd $configRepo
git add -A
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
git diff --cached --quiet || git commit -m "sync: updateskills $timestamp WIB"
git push
```

---

## Step 6 — Laporan Hasil Lengkap

```
=== /updateskills selesai ===

[Config Repo]
- Path: <configRepo>

[GitHub Pull]
- Status: ada update / sudah up-to-date

[Repo → Local (Step 2)]
- Skill baru di-symlink: X skill / tidak ada

[Local → Repo (Step 3)]
- Custom skill baru ditemukan: X skill / tidak ada
- Detail: <nama skill> (atau "tidak ada")

[Registry → Local (Step 4)]
- <repo>: X file baru / already up-to-date / error
- ...

[Push ke GitHub]
- Status: pushed / nothing to push
```
