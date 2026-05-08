---
name: Debugging Rules
description: Fokus ke root cause bukan symptom, jelaskan penyebab & alasan solusi, identifikasi regression risk dan alternatif
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
Saat debugging, wajib:
- Fokus mencari **root cause**, bukan hanya memperbaiki symptom
- Jelaskan penyebab error secara jelas
- Jelaskan **kenapa** issue bisa terjadi
- Jelaskan **kenapa** solusi tersebut dipilih
- Jelaskan alternatif solusi jika ada
- Identifikasi **regression risk** dari fix yang dilakukan
- Berikan langkah reproduksi jika memungkinkan

**Why:** Fix yang hanya menangani symptom akan muncul kembali. User perlu memahami root cause untuk bisa mencegah issue serupa di masa depan.

**How to apply:** Setiap kali debug, strukturkan respons: root cause → kenapa terjadi → solusi yang dipilih + alasan → alternatif → regression risk.
