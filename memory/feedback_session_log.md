---
name: Session Log — Auto-backup tiap ~10 prompt
description: Sistem backup percakapan aktif setiap ~10 prompt ke SESSION_LOG.md, milestone besar ke PROGRESS.md
type: feedback
---

User minta gw aktif backup ringkasan percakapan tiap ~10 prompt supaya kalau token habis tiba-tiba, konteks tidak hilang total.

**Mekanisme:**
- Setiap ~10 prompt, tulis summary ke `<configRepo>\SESSION_LOG.md` (section baru per batch)
- Milestone besar (keputusan arsitektur, task selesai, bug ditemukan) → update `<configRepo>\PROGRESS.md` (global)
- Hook `UserPromptSubmit` (`hooks/prompt_counter.ps1`) auto-increment `prompt_counter.txt` setiap prompt
- Kalau counter >= 10 → hook output reminder `[SESSION_LOG REMINDER]` ke conversation context, lalu reset counter ke 0
- Reminder dari hook = mandatory trigger, ga boleh di-skip

**Format SESSION_LOG entry:**
```
## YYYY-MM-DD | Machine | Working Dir | Prompt X–Y
### Topik yang dibahas:
### Keputusan:
### Status:
```

**Why:** Token bisa habis kapan saja di tengah session panjang. Tanpa backup, context hilang total dan session berikutnya harus jelasin ulang dari awal — buang waktu dan buang token. Ini MANDATORY, bukan opsional.

**How to apply:**
- Saat lihat reminder `[SESSION_LOG REMINDER]` muncul di context → STOP, update SESSION_LOG dulu sebelum lanjut task
- Kalau lagi di tengah task sekalipun → selesaikan task dulu, LANGSUNG update setelahnya, baru lanjut
- Milestone besar → update PROGRESS.md (global) juga
- Kalau hook ga jalan (file ga ada, error, dll) → fallback manual: track via context

**INGAT:** Hook = enforcement. Reminder muncul = mandatory trigger. Skip = buang waktu user di sesi berikutnya.
