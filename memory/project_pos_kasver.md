---
name: KASVER POS - Status Project (React lama + rewrite MVC baru)
description: Project POS milik user — versi React lama di-deprecate, sedang rewrite ke ASP.NET MVC + Razor + Bootstrap, sudah ada backend API real (GENESISPOS). Baca ini sebelum kerja apapun terkait KASVER.
type: project
---

## ⚠️ STATUS TERKINI (per 2026-07-21): REWRITE SELESAI 8/8 PHASE — PENDING BUG FIX DEPLOYMENT

Project React lama **di-deprecate**. Rewrite MVC **100% selesai secara coding** di sisi FE. Backend punya beberapa bug yang perlu di-deploy sebelum shift flow bisa ditest penuh.

## Lokasi Project

- **Frontend MVC (aktif, `Kasver_FE`)**: `D:\2. Office\4. Project\Kasver Git\Kasver_FE` — ASP.NET Core MVC, **.NET 8**
- **Backend API real (`GENESISPOS`)**: source lokal di `D:\2. Office\4. Project\Kasver API Git\GENESISPOS`, tapi Kasver_FE nembak ke **API yang di-publish**: `http://62.146.234.102:5001`. Edit source lokal TIDAK otomatis berlaku sampai di-redeploy.
- **Dokumen** (`D:\2. Office\4. Project\Kasver Git\Doc\`): `PRD.md`, `RESUME.md`, **`PROGRESS.md`** (living document — status detail per-phase, semua bug & gap API tercatat di sini, **BACA INI DULU** tiap mulai sesi baru)
- **React lama (deprecated, referensi)**: `D:\Project\Kasver\pos-frontend-1`

## Kredensial test (seed data, dari `DbInitializer.cs` GENESISPOS)
`admin@kasver.id` / `manager@kasver.id` / `cashier@kasver.id`, password semua: `adminnimda`

## Pola Kerja yang Sudah Divalidasi User (PENTING)

**"FE dulu, BE nyusul"**: kalau backend belum punya endpoint/field, tetap bangun UI + kirim request dengan field/endpoint proposal (didokumentasikan jelas sebagai PROPOSAL di kode + `PROGRESS.md`). Backend nanti nyesuain. Field asing di request JSON diabaikan backend by default.

**CRITICAL — Serialization rule** (belajar dari bug shift sesi 2026-07-21):
- Untuk **response DTO** (deserialisasi dari API): pakai `[JsonPropertyName("snake_case")]` kalau backend return snake_case field names
- Untuk **request DTO** (serialisasi ke API): `[JsonPropertyName]` HANYA kalau backend DTO juga snake_case property names. Kalau backend pakai PascalCase DTO (`public string LastCash { get; set; }`), JANGAN pakai `[JsonPropertyName]` — camelCase default sudah match via `PropertyNameCaseInsensitive = true`. Snake_case tidak resolve case-insensitive karena underscore ≠ capital letter.

## Status per Phase (detail LENGKAP di `Doc/PROGRESS.md`)

| Phase | Modul | Status |
|---|---|---|
| 0 | Fondasi (auth, layout Bootstrap, ApiClient) | ✅ Done |
| 1 | Sales/Kasir (Cashier, Incoming Orders, Cashier Settings, Accumulated Bill) | 🟡 Kode selesai, validasi live BLOCKED oleh Bug #2 |
| 2 | Recipe | ✅ Selesai & tervalidasi PENUH ke API live |
| 3 | Tables (CRUD + drag-drop layout) | ✅ Selesai & tervalidasi PENUH ke API live |
| 4 | Inventory (List+Restock real; Edit Item+Tambah Supplier proposal) | ✅ Selesai & tervalidasi ke API live |
| 5 | Users & Roles | ✅ FE selesai — CRUD sebagian proposal (backend minim) |
| 6 | Settings (Payment Methods CRUD + Settings read-only) | ✅ FE selesai — Payment Methods real, Settings read-only |
| 7 | Reports | ✅ FE selesai — derived dari GET /api/Order (backend tidak punya /reports/*) |
| 8 | Shift standalone | ✅ FE selesai — open/close shift dari /shift page |

## Bug Backend Kritis (root cause + fix di `Doc/PROGRESS.md`)

1. **Bug #1** (`TrShiftRepository.CheckShiftAlreadyOpen` + `GetAll` crash, kolom `firstname` NULL di DB) — **DI-FIX di source** dengan null-coalescing `?? ""` di `TrShiftRepository.cs` (sesi 2026-07-21), tapi **BELUM di-deploy** ke server live. Cek dengan user apakah sudah deploy sebelum asumsikan shift flow jalan normal.
   - Note: Ada juga fix sebelumnya (`MsUserModel.firstname` → nullable) di `GENESISPOS-development` — belum jelas mana yang akhirnya di-deploy. Konfirmasi ke user.
2. **Bug #2** (`GET /api/Order` crash `column t1.price does not exist`) — **BELUM di-fix**, blocking Incoming Orders & Accumulated Bill. Dugaan migration drift.
3. **Bug #3** (FE-side, SUDAH FIX): `CloseShiftRequest` & `OpenShiftRequest` pakai `[JsonPropertyName]` snake_case tapi backend PascalCase → field tidak ter-bind. Diperbaiki sesi 2026-07-21, rebuild clean.

## Kontrak API yang Diusulkan FE (proposal, belum diimplementasi backend)
Detail lengkap di `Doc/PROGRESS.md`: `shift_id` di Order, `order_extras`, `PATCH /api/Order/{id}/Status` + definisi resmi status (1-5), `PUT /api/Item/{id}` (update item), `POST /api/Item/Suppliers`, endpoint `/api/User` (list all users), endpoint update/delete user, endpoint change password.

## Distinguish dari pos-furniture
- `pos-furniture` = Laravel 13 + Next.js 16, lokasi `D:\3. PROJEK\pos-furniture\coding\`, project memory di `project_pos_furniture.md`
- `KASVER` = dulu Vite+React standalone, sekarang ASP.NET MVC + Razor + Bootstrap dengan backend API GENESISPOS

**Why:** Kalau user sebut "POS" tanpa konteks, ada 2 project. Confirm dulu yang mana.
**How to apply:** Saat user minta kerjaan KASVER, **baca `Doc/PROGRESS.md` di project itu dulu** — memory ini ringkasan, `PROGRESS.md` adalah source of truth yang paling update.
