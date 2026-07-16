---
name: .ai/ Workflow — Catatan Penting
description: Workflow .ai/ folder untuk semua project ke depan, plus pitfalls yang perlu diingat
type: feedback
originSessionId: b1e25d18-840f-4670-9dc2-edfbde67b170
---
Gunakan struktur `.ai/` folder untuk semua project baru ke depannya:
- `.ai/current.md` — status project saat ini
- `.ai/decisions.md` — keputusan arsitektur
- `.ai/roadmap.md` — daftar fitur & prioritas
- `.ai/bugs/` — bug penting dan solusinya
- `.ai/archive/` — histori lama, tidak dibaca kecuali diminta

**Yang perlu diperhatikan:**

1. **Template `.ai/current.md` yang kosong adalah red flag** — kalau tidak diisi disiplin tiap sesi, sistemnya mati dan tidak berguna. Selalu isi/update di akhir sesi.

2. **Overlap dengan global CLAUDE.md** — global CLAUDE.md sudah punya rule serupa (baca PROGRESS.md dulu, analisa project dulu). Jika project pakai `.ai/` workflow, `current.md` adalah single source of truth-nya, bukan PROGRESS.md.

3. **Jangan pakai untuk project pendek/eksperimen** — overhead setup `.ai/` lebih besar dari manfaatnya untuk project yang hidupnya < 1 minggu atau sifatnya throwaway.

**Why:** User ingin workflow ini distandardize ke semua project ke depannya agar konteks antar-sesi efisien dan token hemat.

**How to apply:** Di awal setiap project baru, suggest setup `.ai/` folder dengan template ini. Di awal setiap sesi pada project yang sudah pakai `.ai/`, baca `current.md` → `decisions.md` → `roadmap.md` berurutan sebelum mulai.
