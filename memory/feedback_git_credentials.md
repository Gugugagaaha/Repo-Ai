---
name: Git vs gh CLI preference
description: Pakai git langsung kalau credentials sudah ada di Windows Credential Manager, gh hanya fallback
type: feedback
---

Kalau perlu akses GitHub, cek dulu apakah git credentials sudah tersimpan (`git ls-remote` ke repo target). Kalau sudah bisa → langsung pakai `git`, jangan install atau jalankan `gh auth login` dulu.

**Why:** git credentials sudah ada di Windows Credential Manager, tidak perlu repot setup `gh` CLI yang butuh interactive login.

**How to apply:** Sebelum menyarankan `gh auth login`, selalu coba `git ls-remote <repo-url>` dulu. Kalau sukses, lanjut pakai git. `gh` hanya disarankan kalau git credentials benar-benar belum ada.
