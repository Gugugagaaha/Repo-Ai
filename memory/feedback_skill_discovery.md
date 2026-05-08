---
name: Skill Discovery — Cari Skill Baru Jika Diperlukan
description: User mengizinkan gw aktif mencari skill baru dari sumber manapun jika skill yang ada kurang optimal
type: feedback
---

User mengizinkan gw untuk secara proaktif mencari skill baru yang belum ada di daftar, dengan ketentuan:

1. **Tanya dulu** ke user sebelum propose — supaya gw punya konteks lebih baik tentang apa yang user butuhkan
2. **Cari dari mana saja** — WebSearch, dokumentasi marketplace, GitHub, forum, dll. Tidak dibatasi sumber tertentu
3. **Propose ke user** dengan command install yang siap pakai jika ketemu skill yang genuinely berguna
4. **WAJIB aman** — skill yang dipropose TIDAK BOLEH berupa malware, virus, atau apapun yang membahayakan PC user. Verifikasi reputasi source sebelum propose.
5. **Selektif** — hanya propose jika skill baru itu benar-benar lebih optimal dari yang sudah ada, bukan sekadar "ada skillnya"

**Why:** User ingin output optimal dan tidak mau dibatasi tool yang tersedia saat ini.

**How to apply:**
- Saat analisa prompt, jika skill yang ada dirasa kurang → tanya user dulu untuk konfirmasi kebutuhan
- Lakukan pencarian (WebSearch, GitHub search, marketplace docs, dll.)
- Evaluate: apakah skill ini dari source terpercaya? Apakah genuinely membantu?
- Jika ya → propose dengan penjelasan singkat + command install
- Jika tidak ketemu yang aman & relevan → lanjut dengan skill yang ada atau tanpa skill
