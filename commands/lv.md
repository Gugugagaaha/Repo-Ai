---
name: lv
description: Backup ringkasan sesi ini ke PROGRESS.md — catat topik, keputusan, perubahan, dan next steps
---

Buat ringkasan sesi ini dan append ke file `PROGRESS.md` di direktori project saat ini.

Langkah-langkah:
1. Review percakapan sesi ini dari awal hingga akhir
2. Susun ringkasan dengan format berikut:

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
- dst. (tulis "Tidak ada" jika tidak ada perubahan code)

**Pending / Next Steps:**
- [ ] [item 1]
- [ ] [item 2]
- dst. (tulis "Tidak ada" jika semua selesai)

**Catatan Tambahan:**
[hal penting lain yang perlu diingat di sesi berikutnya — konteks, asumsi, warning, dll. Tulis "Tidak ada" jika tidak relevan]
```

3. Jika `PROGRESS.md` sudah ada → append section baru di bagian paling bawah (jangan hapus isi sebelumnya)
4. Jika `PROGRESS.md` belum ada → buat file baru dengan header dan section pertama
5. Konfirmasi ke user bahwa backup berhasil disimpan beserta path file-nya
6. Sync ke GitHub — jalankan perintah berikut secara berurutan via Bash:
   ```
   cd D:/claude-config && git add -A
   git diff --cached --quiet || git commit -m "sync: session recap + memory update $(date +%Y-%m-%d)"
   git push
   ```
   Jika tidak ada perubahan (git diff --cached --quiet sukses), skip commit tapi tetap push.
   Laporkan hasil push ke user (sukses / error).
