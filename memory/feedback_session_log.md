---
name: Session Log — Auto-backup tiap ~10 prompt
description: Sistem backup percakapan aktif setiap ~10 prompt ke SESSION_LOG.md, milestone besar ke PROGRESS.md
type: feedback
---

User minta gw aktif backup ringkasan percakapan tiap ~10 prompt supaya kalau token habis tiba-tiba, konteks tidak hilang total.

**Mekanisme:**
- Setiap ~10 prompt, tulis summary ke `D:\CLAUDE CODE\Config\SESSION_LOG.md` (section baru per batch)
- Milestone besar (keputusan arsitektur, task selesai, bug ditemukan) → update `PROGRESS.md` di project directory
- Tidak pakai hook (Stop hook tidak bisa akses isi conversation)
- Tidak pakai counter file — track sendiri via conversation context

**Format SESSION_LOG entry:**
```
## YYYY-MM-DD | Machine | Working Dir | Prompt X–Y
### Topik yang dibahas:
### Keputusan:
### Status:
```

**Why:** Token bisa habis kapan saja di tengah session panjang. Tanpa backup, context hilang total dan session berikutnya mulai dari nol.

**How to apply:** Di setiap response ke-10 (atau saat milestone besar), sebelum lanjut task, tulis summary dulu ke SESSION_LOG.md. Jangan skip meskipun lagi di tengah task penting — justru itu saat paling kritis untuk backup.
