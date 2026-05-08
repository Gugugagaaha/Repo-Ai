---
name: POS / Cashier System Priority Rules
description: Rules khusus saat project adalah POS/cashier system — prioritaskan transaction stability, role permission, dan jangan break cashier workflow
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
Jika project adalah **POS / cashier system**, prioritaskan:

**Fungsionalitas kritis:**
- Transaction stability
- Fast interaction
- Role permission consistency
- Modal reliability
- Keyboard accessibility
- Table performance
- Responsive cashier workflow
- Stock/update consistency
- State synchronization

**Selalu cek:**
- Double submit prevention
- Rapid interaction / spam click issue
- Role bypass
- Direct URL access tanpa auth
- Responsive cashier layout
- Modal overflow & focus handling
- Transaction flow consistency

**Non-negotiable:**
- **Do not break existing cashier workflow**

**Why:** POS adalah sistem operasional real-time. Bug di transaction flow, role permission, atau double submit langsung berdampak ke operasional bisnis dan integritas data transaksi.

**How to apply:** Saat bekerja pada project POS, prioritaskan checklist ini di atas concern lain. Setiap perubahan yang menyentuh transaction flow atau role logic harus disertai analisa dampak yang eksplisit.
