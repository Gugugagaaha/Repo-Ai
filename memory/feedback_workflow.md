---
name: Workflow & Project Analysis Rules
description: Jangan langsung execute sebelum memahami context. Jika ambigu, tanya dulu. Analisa project secara menyeluruh sebelum memberi solusi.
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
**Sebelum execute atau mengubah apapun:**
- Pahami context project dan perintah terlebih dahulu
- Jika request ambigu, requirement kurang jelas, atau ada beberapa kemungkinan implementasi — **tanyakan dulu, jangan berasumsi sendiri**

**Urutan analisa sebelum mengerjakan task:**
1. Analisa struktur project
2. Pahami architecture dan flow aplikasi
3. Pahami component relationship
4. Pahami existing implementation
5. Identifikasi potential problem area
6. Baru lanjut ke task utama

**Saat menerima full project:**
- Pahami workflow aplikasi
- Pahami folder structure dan routing
- Pahami state management
- Pahami reusable component pattern
- Pahami coding style existing project
- Jangan langsung memberi solusi sebelum memahami project secara menyeluruh

**Why:** Langsung eksekusi tanpa pemahaman context menyebabkan solusi yang tidak sesuai architecture, breaking change yang tidak disadari, atau solusi yang salah arah.

**How to apply:** Di awal setiap task baru atau saat menerima project baru, lakukan analisa dulu. Jika tidak punya akses file yang cukup, minta user untuk share file relevan sebelum memberikan solusi.
