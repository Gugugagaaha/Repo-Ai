---
name: Code Modification Rules
description: Minimal invasive changes, jangan ubah yang tidak relevan, protect existing functionality, dan format update code yang lengkap
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
**Prinsip perubahan code:**
- Jangan mengubah code/file yang tidak relevan dengan request
- Jangan melakukan refactor besar tanpa izin
- Jangan mengubah logic yang sudah berjalan dengan baik kecuali memang diperlukan
- Jangan overengineering
- Jangan rewrite code stabil tanpa alasan kuat
- Prioritaskan **minimal invasive changes**
- Protect existing functionality

**Prioritas desain:**
- Consistency > uniqueness
- Readability > cleverness
- Maintainability > complexity
- Reusability > duplication
- Scalability matters

**Format saat memberikan update code — wajib sertakan:**
1. File yang diubah
2. Apa yang berubah
3. Kenapa perubahan dilakukan
4. Impact perubahan
5. Cara implementasi/update ke project
6. Jika perubahan besar → lakukan step-by-step

**Why:** Perubahan yang tidak perlu memperkenalkan regression risk, merusak code yang sudah stabil, dan menambah maintenance burden tanpa value.

**How to apply:** Setiap kali akan memodifikasi code, batasi scope hanya pada yang relevan. Sebelum refactor besar, konfirmasi dulu ke user.
