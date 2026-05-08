---
name: lv
description: Backup sesi lengkap — update PROGRESS.md, memory files, skills registry, lalu push semua ke GitHub
---

Lakukan backup lengkap sesi ini. Ikuti semua langkah berikut secara berurutan.

---

## Step 1 — Update PROGRESS.md

Review percakapan sesi ini dari awal hingga akhir, susun ringkasan dengan format berikut, lalu append ke `PROGRESS.md` di direktori project saat ini:

```
---

## Sesi [TANGGAL HARI INI] — [WAKTU jika diketahui]

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

Jika `PROGRESS.md` belum ada → buat baru dengan header dan section pertama.

---

## Step 2 — Update Memory Files

Review sesi dan identifikasi hal baru yang perlu disimpan ke memory. Cek setiap kategori:

**Feedback** — apakah user memberikan koreksi, preferensi, atau konfirmasi pendekatan yang non-obvious?
- Jika ya → update file yang relevan di `D:\claude-config\memory\feedback_*.md`
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

## Step 3 — Update MEMORY.md Index

Jika ada memory file baru atau yang diupdate signifikan di Step 2:
- Buka `D:\claude-config\memory\MEMORY.md`
- Tambahkan atau update entri yang relevan (format: `- [Judul](file.md) — satu kalimat hook`)
- Pastikan index tidak melebihi 200 baris

---

## Step 4 — Update Skills Registry (jika ada skill baru)

Jika dalam sesi ini user menyebut skill baru yang diinstall atau repo skill baru:
- Buka `D:\claude-config\skills-registry.md`
- Tambahkan entri baru di tabel yang sesuai (Marketplace / Manual / Custom)
- Jika custom skill → pastikan filenya ada di `D:\claude-config\custom-skills\`

Jika tidak ada skill baru → skip step ini.

---

## Step 5 — Push Semua ke GitHub

Jalankan secara berurutan:

```
cd D:/claude-config && git add -A
git diff --cached --quiet || git commit -m "sync: session backup $(date +%Y-%m-%d)"
git push
```

---

## Step 6 — Laporan ke User

Sampaikan ringkasan apa saja yang diupdate:

```
/lv selesai:
- PROGRESS.md: ✅ diupdate
- Memory files: [X file diupdate / tidak ada yang baru]
- MEMORY.md index: [✅ diupdate / tidak ada perubahan]
- Skills registry: [✅ diupdate / tidak ada skill baru]
- GitHub push: ✅ pushed / nothing to push
```
