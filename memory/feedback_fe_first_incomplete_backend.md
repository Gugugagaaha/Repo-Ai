---
name: FE dulu, BE nyusul — kalau backend belum lengkap
description: Kalau backend API belum punya endpoint/field yang dibutuhkan, tetap bangun FE dengan kontrak yang diusulkan (didokumentasikan jelas), jangan nunggu backend siap dulu
type: feedback
---

Kalau lagi kerja di project yang backend-nya dikerjakan terpisah (oleh user sendiri atau tim lain) dan API-nya belum lengkap/belum ada endpoint yang dibutuhkan — **tetap bangun frontend-nya**, jangan nunggu backend siap dulu. Kirim request dengan field/endpoint yang diusulkan (proposal), backend nanti nyesuain belakangan.

**Why:** User eksplisit bilang ini di project KASVER (rewrite POS ke ASP.NET MVC, backend API `GENESISPOS` terpisah dikerjakan user sendiri): "Lo bisa siapin dulu FE nya biar nanti BEnya bisa mengikuti FE nya" — diulang lagi di konteks lain ("Phase 1 dlu aja lo kelarin, buat dulu tanpa API kalo nanti gw buat API nya biar langsung ngikutin FE"). Ini bukan kasus sekali, tapi preferensi kolaborasi yang konsisten.

**How to apply:**
1. **Desain kontrak API yang masuk akal** berdasarkan pola yang sudah ada di backend (naming convention, struktur DTO existing) — jangan asal karang, cocokkan sama gaya kode yang sudah ada
2. **Dokumentasikan jelas sebagai PROPOSAL** — di komentar kode (kenapa field ini ditambah, endpoint apa yang diharapkan) DAN di dokumen progress project (kalau ada, misal `PROGRESS.md`) — biar siapapun yang pegang backend tau persis apa yang perlu diimplementasi
3. **Field asing di request body biasanya diabaikan backend** (model binding standar ASP.NET/Node/dll skip property yang gak dikenal) — jadi ngirim field proposal itu AMAN, gak merusak call yang sudah berfungsi
4. **Endpoint yang belum ada akan gagal (404/dll) — tangani graceful** (try/catch → pesan/toast informatif "backend belum sediakan fitur ini"), JANGAN biarkan itu crash aplikasi
5. **Verifikasi tetap wajib ke API real** (bukan cuma build sukses) — justru dari situ ketahuan mana yang proposal (gagal graceful) vs mana yang beneran bug (crash tak terduga)

**Kapan TIDAK berlaku:** kalau user secara eksplisit bilang "tunggu backend dulu" atau "saya urus backend duluan" untuk sesuatu — hormati itu, jangan asumsikan FE-first selalu jadi default tanpa dicek dulu di awal task.

Terkait: [[project_pos_kasver]] (project tempat pola ini pertama kali dipakai berulang kali).
