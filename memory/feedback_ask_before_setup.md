---
name: tanya-sebelum-setup
description: Sebelum menjalankan setup/install yang menyangkut path atau migrasi, tanya user dulu pilihan konfigurasinya
type: feedback
---

Sebelum execute setup yang melibatkan path, symlink, atau migrasi data — tanya user dulu:
- Di mana repo mau di-clone / disimpan?
- Apakah mau pakai symlink dan ke mana targetnya?

**Why:** User punya preferensi path spesifik (misalnya `E:\Claude`) yang tidak bisa diduga dari README saja. Langsung execute tanpa tanya bisa salah path.

**How to apply:** Di Phase 1–3 setup (sebelum clone dan symlink), selalu tanya dulu via AskUserQuestion untuk konfigurasi path target sebelum proceed.
