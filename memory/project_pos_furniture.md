---
name: POS Furniture Project State
description: Status phase, tech stack, dan keputusan arsitektur project POS Furniture milik user
type: project
---

## Lokasi Project
`D:\3. PROJEK\pos-furniture\coding\`
- Backend: `coding/backend/` — Laravel 13 + PostgreSQL 17
- Frontend: `coding/frontend/` — Next.js 16 + React 19 + Tailwind 4
- Progress: `coding/Progress.md`

## Status Phase (per 2026-05-09)
- **Phase 1 MVP** ✅ — Auth, Role, Product, Inventory, POS Kasir, Cash Payment, Dashboard
- **Phase 2** ✅ — Supplier, Purchase Order, Goods Receipt, Return (backend + frontend end-to-end)
- **Polish/Security** ✅ — httpOnly cookie BFF, middleware fix, PermissionGuard, PDF Invoice
- **Phase 3** ⬜ — Custom Order, Shipping, Payment Gateway (Midtrans/Xendit)
- **Phase 4** ⬜ — Reports & Export, Analytics lanjutan
- **Phase 5** ⬜ — Multi-store, Performance, Polish UX

## Keputusan Arsitektur Penting
- **Auth**: Sanctum token → disimpan sebagai httpOnly cookie via BFF proxy (`/api/proxy/[...path]`)
- **Pendekatan development**: feature-by-feature (backend minimal dulu, lalu frontend per fitur) — bukan frontend-first atau full-stack sekaligus
- **Stock update**: semua lewat `StockService.increment()` — jangan bypass
- **Nomor dokumen**: `NumberGenerator` pattern `PREFIX-YYYYMMDD-####`, atomic dengan `FOR UPDATE`
- **Return model**: `$table = 'returns'` karena `return` adalah reserved word PHP

## Pending/Backlog Penting
- Unit test: StockService, GoodsReceiptService, ReturnService (belum ada test suite sama sekali)
- QA manual flow Phase 2 di browser
- PostgreSQL trust auth → scram-sha-256 (wajib sebelum production)
- Idempotency cache → Redis (sekarang masih database driver)

**Why:** Project aktif dikerjakan, butuh context resume cepat setiap sesi baru.
**How to apply:** Baca Progress.md dulu saat user balik ke project ini. Jangan mulai coding sebelum tahu phase mana yang sedang aktif.
