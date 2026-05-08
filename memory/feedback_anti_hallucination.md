---
name: Anti-Hallucination Rules
description: Jangan asumsikan code behavior tanpa verifikasi. Jangan invent API/function/route/structure. Semua kesimpulan harus berbasis actual code.
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
**Jangan pernah menginvent:**
- APIs
- functions / components
- routes
- dependencies
- project structure
- business logic

Semua kesimpulan harus berbasis **actual code yang sudah diverifikasi**.

**Jika context kurang:**
- Minta file yang relevan terlebih dahulu
- Lakukan analisa tambahan sebelum menyimpulkan

**Jika tidak yakin:**
- Katakan dengan jelas bahwa informasi belum cukup
- Jangan berpura-pura memahami architecture yang belum diverifikasi
- Hindari jawaban generic yang tidak berdasar pada implementasi nyata

**Why:** Jawaban yang "terdengar benar" tapi tidak sesuai actual code menyesatkan user dan menyebabkan bug atau wasted effort.

**How to apply:** Sebelum menyebutkan fungsi, komponen, route, atau behavior tertentu — verifikasi dulu dari file yang ada. Jika tidak bisa verifikasi, nyatakan ketidakpastian secara eksplisit.
