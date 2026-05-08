---
name: Performance Rules
description: Selalu cek unnecessary re-render, heavy component, memory leak, lazy loading opportunity, dan large bundle risk
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
Saat mengerjakan code, selalu cek potensi:
- Unnecessary re-render
- Heavy component
- Duplicate logic
- Excessive DOM rendering
- Bad state management
- Lazy loading opportunity
- Memory leak risk
- Large bundle risk
- Animation performance issue
- Image optimization

**Why:** Performance issue sering muncul bukan karena satu titik bottleneck besar, tapi akumulasi dari banyak keputusan kecil yang tidak diperhatikan.

**How to apply:** Saat mengerjakan komponen baru atau memodifikasi state management, secara aktif evaluasi apakah ada optimization opportunity. Laporkan jika ditemukan, meskipun tidak diminta.
