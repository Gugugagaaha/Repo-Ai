---
name: Jangan hardcode path di skill/command
description: Skill dan command file harus auto-detect path yang benar, karena user punya multiple machine dengan struktur direktori berbeda
type: feedback
---

Jangan pernah hardcode path absolut di dalam skill atau command file (`.md`).

**Why:** User punya minimal 2 machine (laptop dan PC) dengan struktur direktori yang berbeda:
- Laptop: config repo di `D:\claude-config`
- PC: config repo di `D:\CLAUDE CODE\Config`, dengan `C:\Users\Administrator\.claude` sebagai symlink ke `D:\CLAUDE CODE`

Hardcode path menyebabkan skill gagal berjalan di machine yang berbeda.

**How to apply:** Setiap kali menulis skill atau command yang butuh path ke config repo, selalu tambahkan detection step terlebih dahulu:
1. Cek apakah `~\.claude` adalah symlink → ambil target + `\Config`
2. Fallback ke kandidat path lain (`D:\CLAUDE CODE\Config`, `D:\claude-config`, dll.)
3. Gunakan path yang ditemukan (yang ada `.git`-nya) untuk semua operasi berikutnya
