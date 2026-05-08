---
name: Konfirmasi file target sebelum edit
description: Pastikan file yang diedit adalah file yang benar-benar dimaksud user, bukan file lain dengan konteks serupa
type: feedback
---

Saat user minta perubahan di suatu file/step, pastikan identifikasi file target yang tepat sebelum eksekusi. Jangan langsung edit file yang "terdekat" di konteks tanpa konfirmasi.

**Why:** Pernah terjadi user minta swap step di README.md, tapi gw malah mengubah up.md karena konteks percakapan sedang membahas up.md.

**How to apply:** Kalau ada dua atau lebih file yang relevan dengan request, sebutkan file mana yang akan diedit dan minta konfirmasi jika tidak 100% yakin.
