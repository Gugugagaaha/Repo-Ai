---
name: up
description: Full 2-way sync — pull dari GitHub, update semua komponen sesi ini, push balik ke GitHub, lalu verifikasi local == remote
---

Lakukan full sync sesi ini. Ikuti semua langkah berikut secara berurutan.

---

## Step 0 — Deteksi Config Repo Path

**WAJIB dijalankan pertama sebelum step lain.** Jangan hardcode path apapun — deteksi dulu.

```powershell
$commandsItem = Get-Item "$env:USERPROFILE\.claude\commands" -ErrorAction SilentlyContinue
$claudeItem = Get-Item "$env:USERPROFILE\.claude" -ErrorAction SilentlyContinue
$candidates = @()
if ($commandsItem.LinkType -eq "SymbolicLink") {
    $candidates += Split-Path $commandsItem.Target -Parent
}
if ($claudeItem.LinkType -eq "SymbolicLink") {
    $candidates += Join-Path $claudeItem.Target "Config"
}
$candidates += "D:\Claude\Config", "D:\CLAUDE CODE\Config", "D:\claude-config", "$env:USERPROFILE\.claude\Config"
$configRepo = $candidates | Where-Object { $_ -and (Test-Path "$_\.git") } | Select-Object -First 1
if (-not $configRepo) { Write-Error "Config repo tidak ditemukan di kandidat manapun!"; exit 1 }
Write-Host "Config repo ditemukan: $configRepo"
```

Simpan nilai `$configRepo` ini — gunakan sebagai base path di semua step berikutnya (gantikan semua referensi path config repo).

---

## Step 1 — Fetch & Compare Remote vs Local

Jangan langsung pull. Fetch dulu, lalu compare — pastikan tidak ada file yang salah terhapus di local sebelum sync.

```powershell
cd "<configRepo dari Step 0>"
git fetch origin
```

Setelah fetch, jalankan comparison:

```powershell
# Lihat status local (untracked, modified, deleted)
git status --short

# Lihat diff local vs remote secara detail
git diff --name-status origin/master HEAD
```

Interpretasi output `git diff --name-status origin/master HEAD`:
- `A` = file baru di local (belum ada di remote) → aman, akan di-push
- `M` = file dimodifikasi di local → aman, akan di-push
- `D` = file ada di remote tapi **tidak ada di local** → ⚠️ POTENSI SALAH HAPUS

---

## Step 1.5 — Safety Check: Deteksi File Terhapus

**Wajib dijalankan sebelum pull atau push apapun.**

Cek apakah ada file dengan status `D` dari output Step 1:

```powershell
$deleted = git diff --name-status origin/master HEAD | Where-Object { $_ -match '^D\t' }
```

**Jika `$deleted` kosong** → tidak ada file terhapus, lanjut ke Step 1.6.

**Jika `$deleted` ada isinya** → STOP. Tampilkan warning ke user:

```
⚠️  FILE TERHAPUS DI LOCAL — BELUM ADA DI REMOTE:
[daftar file yang terhapus]

Pilihan:
  [R] Restore dari remote (lo salah hapus)
  [K] Keep deletion (memang sengaja dihapus, push ke remote)
```

Tunggu konfirmasi user sebelum lanjut.

- Jika user pilih **Restore**:
```powershell
# Restore file dari remote
git checkout origin/master -- <nama-file>
# Ulangi untuk setiap file yang mau di-restore
```

- Jika user pilih **Keep** → catat, lanjut ke Step 1.6 (file akan ikut ter-push sebagai deletion).

---

## Step 1.6 — Pull / Merge dari Remote

Setelah safety check selesai, baru merge perubahan dari remote:

```powershell
cd "<configRepo dari Step 0>"
git merge origin/master
```

Jika ada conflict → selesaikan dulu, laporkan ke user sebelum lanjut.

---

## Step 2 — Update SESSION_LOG.md (mandatory tiap sesi)

Append entry baru ke `<configRepo>\SESSION_LOG.md` untuk sesi ini. Format:

```
---

## YYYY-MM-DD HH:mm WIB | <perangkat: PC/Laptop> | <cwd> | Prompt <range>

### Topik yang dibahas:
1. [poin singkat 1]
2. [poin singkat 2]
- dst.

### Keputusan:
- [keputusan 1] (tulis "Tidak ada" jika tidak ada)

### Status:
[ringkasan singkat: ada task coding aktif / sesi diskusi saja / dll]
```

Aturan:
- Jam pakai WIB (UTC+7) dari waktu commit
- Prompt range = total prompt user di sesi ini (estimasi dari `prompt_counter.txt` atau hitung manual dari context)
- Jangan hapus entry lama — selalu append di bawah

---

## Step 3 — Update PROGRESS.md (global, hanya untuk milestone)

PROGRESS.md sekarang **global** di `<configRepo>\PROGRESS.md` — bukan per-project lagi.

Hanya update PROGRESS.md kalau sesi ini menghasilkan milestone besar / keputusan struktural:
- Skip kalau cuma diskusi atau task kecil — cukup di SESSION_LOG saja
- Update kalau ada: keputusan arsitektur, fitur baru selesai, refactor besar, setup tooling baru

Format entry baru di PROGRESS.md:

```
---

## Sesi [YYYY-MM-DD HH:mm WIB]

**Konteks / Topik Utama:**
[1-2 kalimat tentang apa yang dikerjakan di sesi ini]

**Poin-Poin Penting:**
- [poin 1]
- [poin 2]
- dst.

**Keputusan yang Dibuat:**
- [keputusan 1]
- [keputusan 2]
- dst. (tulis "Tidak ada" jika tidak ada keputusan besar)

**Perubahan yang Dilakukan:**
- [file/komponen/config yang diubah dan ringkasan perubahannya]
- dst. (tulis "Tidak ada" jika tidak ada perubahan)

**Pending / Next Steps:**
- [ ] [item 1]
- dst. (tulis "Tidak ada" jika semua selesai)

**Catatan Tambahan:**
[hal penting lain yang perlu diingat — konteks, asumsi, warning. Tulis "Tidak ada" jika tidak relevan]
```

Jika sesi ini tidak ada milestone → skip step ini, lanjut ke Step 4.

---

## Step 4 — Update Memory Files

Review sesi dan identifikasi hal baru yang perlu disimpan ke memory. Cek setiap kategori:

**Feedback** — apakah user memberikan koreksi, preferensi, atau konfirmasi pendekatan yang non-obvious?
- Jika ya → update file yang relevan di `<configRepo>\memory\feedback_*.md`
- Jika ada feedback baru yang belum punya file → buat file baru dengan format frontmatter yang benar

**User** — apakah ada info baru tentang role, keahlian, atau preferensi user yang terungkap?
- Jika ya → update atau buat file `user_*.md` di folder memory

**Project** — apakah ada keputusan project, deadline, atau konteks baru yang penting?
- Jika ya → update atau buat file `project_*.md` di folder memory

**Reference** — apakah ada resource eksternal baru (repo, link, tool) yang relevan untuk sesi berikutnya?
- Jika ya → update atau buat file `reference_*.md` di folder memory

Format frontmatter wajib untuk setiap memory file:
```
---
name: [nama memory]
description: [satu kalimat deskripsi — dipakai untuk menentukan relevansi di sesi berikutnya]
type: [feedback | user | project | reference]
---

[isi memory]
```

---

## Step 5 — Update MEMORY.md Index

Jika ada memory file baru atau yang diupdate signifikan di Step 4:
- Buka `<configRepo>\memory\MEMORY.md`
- Tambahkan atau update entri yang relevan (format: `- [Judul](file.md) — satu kalimat hook`)
- Pastikan index tidak melebihi 200 baris

---

## Step 6 — Update Skills Registry (jika ada skill baru)

Jika dalam sesi ini user menyebut skill baru yang diinstall atau repo skill baru:
- Buka `<configRepo>\skills-registry.md`
- Tambahkan entri baru di tabel yang sesuai (Marketplace / Manual / Custom)
- Jika custom skill → pastikan filenya ada di `<configRepo>\custom-skills\`

Jika tidak ada skill baru → skip step ini.

---

## Step 7 — Sync File Repo Lainnya

Cek apakah ada perubahan di file-file berikut yang terjadi di sesi ini (selain memory dan PROGRESS.md):

- `<configRepo>\CLAUDE.md` — ada rule baru atau perubahan behavior?
- `<configRepo>\commands\` — ada command baru atau yang diubah? (termasuk file up.md ini jika diubah)
- `<configRepo>\custom-skills\` — ada custom skill baru atau yang diubah?
- `<configRepo>\setup.ps1` — ada perubahan script setup?
- `<configRepo>\README.md` — ada perubahan dokumentasi?
- `<configRepo>\SETUP_PROMPT.md` — ada perubahan instruksi setup?

Jika ada file yang berubah tapi belum masuk ke staging → pastikan ikut di-commit di Step 8.

---

## Step 8 — Commit & Push ke GitHub

Sebelum staging, tampilkan dulu apa yang akan di-commit:

```powershell
cd "<configRepo dari Step 0>"
git status --short
```

Laporkan ke user secara singkat:
- File baru yang akan di-push
- File yang dimodifikasi
- File yang akan dihapus dari remote (kalau ada — hanya kalau user sudah konfirmasi di Step 1.5)

Jika semua sudah sesuai, baru commit & push (commit message **wajib include jam WIB** untuk audit):

```powershell
git add -A
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
git diff --cached --quiet || git commit -m "sync: $timestamp WIB"
git push
```

---

## Step 9 — Verifikasi Local == Remote

Pastikan local sudah in-sync dengan GitHub:

```powershell
cd "<configRepo dari Step 0>"
git status
git log --oneline -3
git fetch origin
git diff HEAD origin/master --stat
```

**Yang harus terpenuhi:**
- `git status` → `nothing to commit, working tree clean`
- `git diff HEAD origin/master` → tidak ada output (tidak ada perbedaan)

Jika masih ada diff → investigasi dan selesaikan sebelum laporan ke user.

---

## Step 10 — Laporan ke User

Sampaikan ringkasan apa saja yang diupdate:

```
/up selesai:
- Config repo    : <path yang dideteksi di Step 0>
- Safety check   : ✅ tidak ada file terhapus / ⚠️ [X file] ditemukan → [restored/deleted]
- GitHub pull    : ✅ up to date / [X commit pulled dari remote]
- SESSION_LOG    : ✅ entry baru ditambah (prompt <range>)
- PROGRESS.md    : ✅ milestone ditambah / skip (bukan milestone)
- Memory files   : [X file diupdate / tidak ada yang baru]
- MEMORY.md index: [✅ diupdate / tidak ada perubahan]
- Skills registry: [✅ diupdate / tidak ada skill baru]
- File lainnya   : [daftar file yang ikut diupdate / tidak ada]
- GitHub push    : ✅ pushed (commit: sync: YYYY-MM-DD HH:mm WIB) / nothing to push
- Verifikasi sync: ✅ local == remote
```
