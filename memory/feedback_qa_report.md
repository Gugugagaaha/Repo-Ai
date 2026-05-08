---
name: QA Report — append, jangan replace
description: Setelah setiap audit QA, hasil baru harus di-append ke file QA_REPORT yang sudah ada — tidak boleh menghapus laporan sebelumnya
type: feedback
originSessionId: 95f01ab2-6c1e-4105-ae83-e0d3e77752cd
---
Setiap kali selesai melakukan QA audit pada sebuah proyek, **update file `QA_REPORT.md` (atau nama serupa) dengan menambahkan section baru di bawah, tanpa menghapus atau mengganti laporan-laporan sebelumnya**. Setiap audit jadi entri historis yang bisa ditelusuri.

Format yang diharapkan:
- Tambahkan delimiter yang jelas (mis. `---` + heading audit baru dengan tanggal)
- Cantumkan tanggal audit, baseline yang dibandingkan, dan status diff (solved / partial / unresolved)
- Pertahankan seluruh konten laporan lama persis seperti aslinya

**Why:** User ingin trail historis audit terjaga sebagai catatan progres proyek dari waktu ke waktu — laporan lama berfungsi sebagai baseline untuk audit berikutnya, dan menghapusnya merusak kemampuan tracking perbaikan.

**How to apply:** Berlaku untuk semua proyek yang punya file QA report. Setelah QA selesai, default tindakan adalah append ke file existing (gunakan Edit untuk menambahkan section di bagian akhir, atau Write hanya jika file belum ada). Jika user meminta laporan terpisah, konfirmasi dulu sebelum membuat file baru.
