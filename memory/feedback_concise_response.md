---
name: Response ringkas — langsung ke inti
description: User prefer response yang ringkas dan langsung ke kesimpulan/action. Tidak perlu penjelasan panjang kecuali user explicit minta detail.
type: feedback
---

User prefer response ringkas. Langsung ke inti / kesimpulan / action.

**Why:** User udah aware konteksnya, ga perlu di-recap. Penjelasan panjang malah bikin user harus scroll lama buat tau "jadi gimana?". Lebih efisien kalau Claude langsung kasih kesimpulan + action, baru kasih detail kalau ditanya.

**How to apply:**
- Jawab inti question dulu (1-3 kalimat)
- Action item jelas: apa yang akan dikerjakan, atau apa yang user perlu putuskan
- Detail/reasoning di-expose hanya kalau user tanya "kenapa" atau "jelasin"
- Kalau ada multiple options/risks, list singkat aja — bukan paragraph panjang
- Pengecualian: kalau task ambigu / risky / breaking change → tetap kasih warning + reasoning karena itu kontekstual penting

**Sinyal user butuh detail:**
- "kenapa?", "jelasin", "kasih reasoning"
- Atau user tanya teknis spesifik
