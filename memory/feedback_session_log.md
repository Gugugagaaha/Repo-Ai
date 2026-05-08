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

**Why:** Token bisa habis kapan saja di tengah session panjang. Tanpa backup, context hilang total dan session berikutnya harus jelasin ulang dari awal — buang waktu dan buang token. Ini MANDATORY, bukan opsional.

**How to apply:**
- **WAJIB** update SESSION_LOG.md setiap 10 prompt — tidak boleh skip, tidak ada pengecualian
- Hitung prompt sendiri dari awal session atau dari update terakhir
- Kalau lagi di tengah task sekalipun → selesaikan task dulu, LANGSUNG update setelahnya, baru lanjut
- Milestone besar → update PROGRESS.md juga
- Kalau kelewat → akui dan update segera, jangan dibiarkan makin lama

**INGAT:** User sudah tegas soal ini. Skip = buang waktu user di sesi berikutnya.
