---
name: updateskills
description: Sync skills dua arah — push custom skill baru ke GitHub, pull & install skill baru dari registry
---

Lakukan skill sync dua arah antara perangkat ini dan GitHub repo config. Ikuti langkah-langkah berikut secara berurutan dan laporkan hasilnya.

---

## Step 1 — Pull latest dari GitHub

```
cd D:/claude-config && git pull
```

Catat hasilnya: ada perubahan baru atau sudah up-to-date.

---

## Step 2 — Deteksi custom skill baru di perangkat ini (Local → GitHub)

Scan `~/.claude/skills/` untuk item yang **bukan symlink** (artinya belum dibackup ke repo):

```powershell
Get-ChildItem "$env:USERPROFILE\.claude\skills" | Where-Object { $_.LinkType -ne "SymbolicLink" }
```

Untuk setiap item yang ditemukan:
- Jika berupa **folder** dengan file `SKILL.md` di dalamnya → ini **custom skill baru**, lakukan:
  1. Copy ke `D:\claude-config\custom-skills\<nama-folder>\`
  2. Hapus folder asli: `Remove-Item "$env:USERPROFILE\.claude\skills\<nama>" -Recurse -Force`
  3. Buat symlink: `New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\<nama>" -Target "D:\claude-config\custom-skills\<nama>"`
  4. Tambahkan entry baru di tabel **Custom Skills** dalam `D:\claude-config\skills-registry.md` — isi kolom Skill, Path di repo, dan Keterangan (tebak dari isi SKILL.md)
- Jika berupa **file .md tunggal** (bukan folder) → skill dari marketplace, abaikan

---

## Step 3 — Install/update skill dari registry (GitHub → Local)

Baca `D:\claude-config\skills-registry.md` dan ekstrak semua repo dari tabel **Manual Skills**.

Untuk setiap repo, jalankan:

```powershell
$repoSlug  = "<owner>/<repo>"     # dari kolom Repo di registry
$searchDir = "<folder>"            # dari kolom "Cari / Folder" (default: "skills")
$cacheDir  = "D:\claude-config\skills-cache\$($repoSlug.Split('/')[1])"
$skillsDir = "$env:USERPROFILE\.claude\skills"

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

Lakukan ini untuk semua repo berikut (sesuai isi registry saat ini):
- kostja94/marketing-skills → folder `skills`
- coreyhaines31/marketingskills → folder `skills`
- AgriciDaniel/claude-seo → folder `skills`
- zubair-trabzada/geo-seo-claude-skills → folder `skills`
- nexu-io/open-design → folder `skills`
- ComposioHQ/awesome-claude-skills → cari subfolder `brand-build-skills`
- garrytan/gstack → folder `skills`
- garrytan/gbrain → folder `skills`
- Orchestra-Research/AI-Research-SKILLs → folder `skills`
- VoltAgent/awesome-agent-skills → folder `skills`
- Lum1104/Understand-Anything → folder `skills`

> **Catatan:** Jika kolom "Cari / Folder" di registry berubah (ada repo baru), baca ulang dari file registry — list di atas hanya default, selalu prioritaskan isi `skills-registry.md` yang aktual.

Catat berapa file baru berhasil di-copy untuk setiap repo.

---

## Step 4 — Push jika ada perubahan lokal

```
cd D:/claude-config && git add -A
git diff --cached --quiet || git commit -m "sync: updateskills $(date +%Y-%m-%d)"
git push
```

---

## Step 5 — Laporkan hasil lengkap

Format laporan:

```
=== /updateskills selesai ===

[GitHub Pull]
- Status: (ada update / sudah up-to-date)

[Custom Skills Baru (Local → GitHub)]
- Ditemukan: X skill baru
- Detail: <nama skill> (atau "tidak ada")

[Registry Skills (GitHub → Local)]
- <repo>: X file baru / already up-to-date / error
- ...

[Push ke GitHub]
- Status: (pushed / nothing to push / error)
```
