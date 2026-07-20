---
name: tanya-sebelum-setup
description: Sebelum menjalankan setup/install/eksekusi tahap besar (path, symlink, migrasi, install tooling baru, scaffold project), tanya user dulu — jangan langsung eksekusi meski sudah dijelaskan rencananya
type: feedback
---

Sebelum execute setup yang melibatkan path, symlink, migrasi data, **install tooling baru, atau scaffold project baru** — tanya user dulu:
- Di mana repo/project mau disimpan?
- Apakah mau pakai symlink dan ke mana targetnya?
- Untuk instalasi/eksekusi bertahap (mis. install SDK → scaffold → wiring data): **list dulu semua yang dibutuhkan per tahap, JANGAN eksekusi apapun sampai user bilang eksplisit "mulai"/"jalanin" per tahap.**

**Why:** User punya preferensi path spesifik (misalnya `E:\Claude`, atau `D:\Project\KASVER MVC`) yang tidak bisa diduga dari README/asumsi saja. User juga eksplisit pernah bilang: "untuk pelaksanaan nanti lo tanya gw aja apakah udah mau dilaksanain atau engga" — pola ini muncul berulang di konteks berbeda (setup config repo, lalu rewrite project KASVER ke MVC), jadi ini preferensi umum bukan kasus khusus. Langsung execute tanpa tanya bisa salah path, atau install/scaffold sesuatu yang ternyata belum waktunya (mis. install .NET SDK sebelum user siap, padahal masih nunggu API spec).

**How to apply:** Kapanpun mau mulai fase eksekusi nyata (bukan cuma diskusi/riset/baca kode) — terutama: install software baru, clone/scaffold project, symlink, migrasi data — selalu presentasikan dulu **list rencana + prasyarat** secara lengkap, baru tanya izin eksplisit (via AskUserQuestion atau pertanyaan langsung) sebelum proceed ke eksekusi. Ini berlaku per-tahap kalau task-nya multi-fase, bukan cuma di awal.
