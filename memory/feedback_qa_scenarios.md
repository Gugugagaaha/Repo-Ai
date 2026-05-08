---
name: QA wajib test positif & negatif scenario
description: Setiap aktivitas QA atau testing harus mencakup positive scenarios (happy path) dan negative scenarios (error/edge cases) — bukan hanya happy path
type: feedback
originSessionId: 95f01ab2-6c1e-4105-ae83-e0d3e77752cd
---
Saat melakukan QA, testing, atau verifikasi fitur, **wajib** mencakup dua kategori scenario:

**Positive scenarios (happy path):**
- Input valid, flow normal, expected behavior tercapai
- Use case standar yang user normal lakukan

**Negative scenarios (error/edge cases):**
- Input invalid (kosong, null, negative, melewati batas)
- Stock/quota habis
- Permission denied / role bypass
- Race conditions (rapid click, double submit, simultaneous action)
- Network error / service failure
- Edge case data (empty array, sangat banyak, special character)
- Idempotency check (re-trigger action yang sama)
- Recovery dari failed state
- User memutuskan flow di tengah (back, refresh, navigate away)

**Why:** Hanya test happy path = false sense of security. Bug paling berbahaya muncul di edge case dan unhappy path. Senior QA selalu mencoba "bagaimana cara user bisa merusak aplikasi ini?".

**How to apply:**
- Setiap kali menyusun test scenario / test plan / verifikasi fitur baru, susun **dua section terpisah**: Positive dan Negative
- Minimal 1 negative scenario untuk setiap positive scenario kunci
- Untuk POS / cashier: prioritaskan negative scenario seputar transaction stability, double submit, insufficient stock, role bypass, refresh-mid-flow, race condition antar cashier
- Lapor temuan dari negative scenario walaupun tidak diminta secara eksplisit
