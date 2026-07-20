---
name: KASVER POS - Status Project (React lama + rewrite MVC baru)
description: Project POS milik user — versi React lama di-deprecate, sedang rewrite ke ASP.NET MVC + Razor + Bootstrap, sudah ada backend API real (GENESISPOS). Baca ini sebelum kerja apapun terkait KASVER.
type: project
---

## ⚠️ STATUS TERKINI (per 2026-07-21): REWRITE AKTIF DIKERJAKAN, 4/8 PHASE SELESAI

Project React lama **di-deprecate**. Rewrite MVC **bukan lagi tahap dokumentasi doang** — udah ada kode jalan, sebagian besar tervalidasi ke API live sungguhan. Jangan asumsikan React masih aktif; kalau user minta kerjaan KASVER, itu hampir pasti soal MVC baru kecuali disebutkan eksplisit.

## Lokasi Project (SUDAH PINDAH dari catatan lama — path `KASVER MVC` sudah tidak dipakai)

- **Frontend MVC (aktif, `Kasver_FE`)**: `D:\Project\KASVER Git\Kasver_FE` — ASP.NET Core MVC, **.NET 8** (bukan 10)
- **Backend API real (`GENESISPOS`)**: `D:\Project\GENESISPOS-development` — source lokal, tapi Kasver_FE nembak ke **API yang sudah di-publish**: `http://62.146.234.102:5001` (di `appsettings.json` Kasver_FE). Edit source lokal TIDAK otomatis berlaku sampai di-redeploy — Claude gak punya akses deploy.
- **Dokumen** (`D:\Project\KASVER Git\Doc\`): `PRD.md` (requirement aplikasi), `RESUME.md` (risiko migrasi teknis), **`PROGRESS.md`** (living document — status per-phase, semua bug & gap API tercatat detail di sini, BACA INI DULU tiap mulai sesi baru terkait KASVER)
- **React lama (deprecated, referensi)**: `D:\Project\Kasver\pos-frontend-1`

## Kredensial test (seed data, dari `DbInitializer.cs` GENESISPOS)
`admin@kasver.id` / `manager@kasver.id` / `cashier@kasver.id`, password semua: `adminnimda`

## Pola Kerja yang Sudah Divalidasi User (PENTING, generalizable)

User eksplisit minta pola **"FE dulu, BE nyusul"**: kalau backend belum punya endpoint/field yang dibutuhkan, tetap bangun UI + kirim request dengan field/endpoint yang diusulkan (didokumentasikan jelas sebagai PROPOSAL di kode + `PROGRESS.md`), backend nanti nyesuain. Jangan nunggu backend siap dulu. Field asing di request JSON diabaikan backend by default (gak breaking), endpoint yang belum ada di-handle graceful (try/catch → toast warning, bukan crash).

**Metodologi verifikasi WAJIB:** bukan cuma `dotnet build` sukses — tiap fitur harus dites BENERAN ke API live (login pakai kredensial di atas, curl manual dengan cookie jar + antiforgery token kalau browser extension gak konek). Data tes yang bisa di-cleanup (create+delete) harus dibersihkan; kalau ada efek permanen yang gak bisa di-undo (misal Restock inventory, gak ada endpoint kurangi stok balik), laporkan transparan ke user, jangan disembunyikan.

## Status per Phase (ringkasan — detail LENGKAP ada di `Doc/PROGRESS.md`, jangan duplikat di sini)

| Phase | Modul | Status |
|---|---|---|
| 0 | Fondasi (auth, layout Bootstrap, ApiClient) | ✅ Done |
| 1 | Sales/Kasir (Cashier, Incoming Orders, Cashier Settings, Accumulated Bill) | 🟡 Kode 100% selesai, validasi live BLOCKED oleh Bug #2 |
| 2 | Recipe | ✅ Selesai & tervalidasi PENUH ke API live |
| 3 | Tables (CRUD + drag-drop layout) | ✅ Selesai & tervalidasi PENUH ke API live |
| 4 | Inventory (List+Restock real; Edit Item+Tambah Supplier proposal) | ✅ Selesai & tervalidasi ke API live |
| 5 | Users & Roles | Belum, API sangat minim |
| 6 | Settings (General/Tax/Payment Methods) | Belum, API sebagian |
| 7 | Reports (halaman lengkap, beda dari Dashboard) | Belum, API gak ada sama sekali |
| 8 | Shift (halaman standalone) | Belum |

## Bug Backend Kritis (root cause + fix ada di `Doc/PROGRESS.md`)

1. **Bug #1** (`TrShiftRepository.CheckShiftAlreadyOpen` crash, kolom `firstname` NULL) — **SUDAH DI-FIX di source `GENESISPOS-development`** (`MsUserModel` jadi nullable) tapi **BELUM di-deploy** ke server live. Cek dengan user apakah sudah deploy sebelum asumsikan shift flow jalan normal.
2. **Bug #2** (`GET /api/Order` crash, `column t1.price does not exist`, dugaan migration drift) — **BELUM di-fix**, gak ada akses DB. Blocking Incoming Orders & Accumulated Bill.

## Kontrak API yang Diusulkan FE (proposal, belum diimplementasi backend)
Detail lengkap di `Doc/PROGRESS.md` — ringkasan: `shift_id` di Order, `order_extras` (extra items lepas di cart), `PATCH /api/Order/{id}/Status` + definisi resmi status (1-5), entity `/api/Bundle` penuh, `PUT /api/Item/{id}` (update item — backend gak punya endpoint update item sama sekali), `POST /api/Item/Suppliers` (tambah supplier — gak ada endpoint sama sekali).

## Distinguish dari pos-furniture
- `pos-furniture` = Laravel 13 + Next.js 16, lokasi `D:\3. PROJEK\pos-furniture\coding\`, project memory di `project_pos_furniture.md`
- `KASVER` = dulu Vite+React standalone, sekarang ASP.NET MVC + Razor + Bootstrap dengan backend API GENESISPOS

**Why:** Kalau user sebut "POS" tanpa konteks, ada 2 project. Confirm dulu yang mana.
**How to apply:** Saat user minta kerjaan KASVER, **baca `Doc/PROGRESS.md` di project itu dulu** sebelum kerja apapun — jangan andalkan memory ini aja, karena project ini berkembang cepat tiap sesi dan `PROGRESS.md` adalah source of truth yang paling update.
