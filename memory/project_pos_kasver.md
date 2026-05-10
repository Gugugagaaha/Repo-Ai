---
name: KASVER POS (pos-frontend) - Status Project
description: Project frontend POS standalone milik user, beda dari pos-furniture; status mock mode, ada QA_REPORT komprehensif
type: project
---

## Lokasi Project
`D:\3. PROJEK\pos-frontend\`

## Stack
- Vite 5 + React 18 + Zustand + React Router 6
- Tailwind CSS 3, Axios, Recharts, lucide-react
- ~46 jsx/js files, 7080 LoC di pages

## Status (per 2026-05-10)
- **Mode:** MOCK MODE — backend di-mock via `MOCK_USERS`, `MOCK_ORDERS`, dll di `src/constants/mockData.js`
- **Production Readiness:** 38/100 — NOT PRODUCTION READY
- **Known critical bugs (belum di-fix):**
  - Bug akuntansi shift: formula diff asumsi semua revenue cash (ShiftPage.jsx:38)
  - Double-submit payment: no isProcessing state di PaymentModal/TableBillModal
  - Order ID collision: generateOrderId pakai MOCK_ORDERS.length+1 (order.service.js:51-54)
  - Cart loss: cartStore tidak pakai persist middleware
- **Verified fixed dari audit lama:** MOCK_TABLES ReferenceError, unit conversion gram↔kg

## Reference
- `QA_REPORT.md` di project root — 2662 baris, multi-session findings (latest: 2026-05-10 22:55 WIB QA Deep Review)
- `scripts/qa-test.mjs` — node integration test, 17-30 scenarios di service layer
- Format append-only ke QA_REPORT (sesuai feedback_qa_report rule)

## Distinguish dari pos-furniture
- `pos-furniture` = Laravel 13 + Next.js 16, lokasi `D:\3. PROJEK\pos-furniture\coding\`, project memory di `project_pos_furniture.md`
- `pos-frontend` (KASVER) = Vite + React standalone, lokasi `D:\3. PROJEK\pos-frontend\`

**Why:** Kalau user sebut "POS" tanpa konteks, ada 2 project. Confirm dulu yang mana.
**How to apply:** Saat user minta kerjaan POS, tanya project mana atau lihat path. Baca QA_REPORT.md dulu kalau ke pos-frontend.
