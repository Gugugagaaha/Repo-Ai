---
name: KASVER POS - Status Project (React lama + rewrite MVC baru)
description: Project POS milik user — versi React lama di-deprecate, sedang REWRITE TOTAL ke ASP.NET MVC + Razor + Bootstrap. Baca ini sebelum kerja apapun terkait KASVER.
type: project
---

## ⚠️ STATUS TERKINI (per 2026-07-20): SEDANG REWRITE KE MVC + RAZOR + BOOTSTRAP

Project React lama **di-deprecate**, sedang dibangun ulang total di stack baru. Jangan asumsikan React masih jadi versi aktif kalau user minta kerjaan KASVER — konfirmasi dulu React lama atau MVC baru.

## Lokasi Project

- **React lama (deprecated, tetap disimpan sebagai referensi):** `D:\Project\Kasver\pos-frontend-1` (pindah dari lokasi lama `D:\3. PROJEK\pos-frontend\` — sudah tidak ada, path lama basi)
- **MVC baru (aktif dikerjakan):** `D:\Project\KASVER MVC` — berisi `PRD.md` (requirement aplikasi) dan `RESUME.md` (risiko teknis migrasi). Belum ada scaffolding/kode, baru tahap dokumentasi.

## Stack

**Lama (React, deprecated):**
- Vite 5 + React 18 + Zustand + React Router 6, Tailwind CSS 3, Axios, Recharts, lucide-react
- ~46 jsx/js files, 7080 LoC di pages

**Baru (target rewrite):**
- ASP.NET Core MVC + Razor Views + Bootstrap
- .NET SDK 10.0 (stable/LTS terbaru per Juli 2026) — **belum terinstall** di PC ini, menunggu izin eksekusi
- Backend API sudah ada di sisi user (bukan dibikin dari nol), spec belum diberikan — blocker utama untuk wiring data

## Kenapa Rewrite (bukan preferensi teknis semata)

User bilang eksplisit: ini requirement, bukan karena gak sreg sama React. 4 critical bug lama di-defer, fokus rewrite dulu.

## Status React Lama (per 2026-05-10, sebelum keputusan rewrite)
- **Mode:** MOCK MODE — backend di-mock via `MOCK_USERS`, `MOCK_ORDERS`, dll di `src/constants/mockData.js`
- **Production Readiness:** 38/100 — NOT PRODUCTION READY
- **Known critical bugs (di-defer, BELUM di-fix, relevansi di MVC baru dicatat di `RESUME.md`):**
  - Bug akuntansi shift: formula diff asumsi semua revenue cash (`ShiftPage.jsx:38` — `closing_cash - opening_cash - total_revenue`, tidak exclude pendapatan non-tunai)
  - Double-submit payment: no isProcessing state di PaymentModal/TableBillModal
  - Order ID collision: generateOrderId pakai MOCK_ORDERS.length+1 (order.service.js:51-54)
  - Cart loss: cartStore tidak pakai persist middleware
- **Verified fixed dari audit lama:** MOCK_TABLES ReferenceError, unit conversion gram↔kg

## Domain Model (hasil investigasi source code, dasar PRD.md aplikasi baru)
5 role dengan permission matrix granular (super_admin, manager, cashier, kitchen, warehouse), 10 modul (Auth, Dashboard, Sales/Kasir, Incoming Orders, Reservations, Cashier Settings, Inventory, Recipe, Reports, Shift, Tables, Settings, Users), 16 entitas data. Detail lengkap ada di `D:\Project\KASVER MVC\PRD.md` — jangan duplikat di sini, rujuk file itu.

## Reference
- `D:\Project\KASVER MVC\PRD.md` — requirement aplikasi (produk)
- `D:\Project\KASVER MVC\RESUME.md` — risiko & pertimbangan teknis migrasi (full rewrite bukan port, risiko UX Razor server-rendered vs kebutuhan fast-interaction POS/kasir, status bug lama di paradigma baru)
- `D:\Project\Kasver\pos-frontend-1\QA_REPORT.md` — 2662 baris, histori QA React lama (latest: 2026-05-10 22:55 WIB QA Deep Review)

## Pending / Blocker
- User belum kasih izin eksekusi tahap 1 (install .NET SDK 10.0) — **jangan mulai install/scaffold tanpa tanya dulu**, lihat `feedback_ask_before_setup.md`
- API spec dari user belum ada — blocker wiring data layer
- Konfirmasi final scope 14 halaman belum diberikan

## Distinguish dari pos-furniture
- `pos-furniture` = Laravel 13 + Next.js 16, lokasi `D:\3. PROJEK\pos-furniture\coding\`, project memory di `project_pos_furniture.md`
- `KASVER` = dulu Vite+React standalone, sekarang rewrite ke ASP.NET MVC + Razor + Bootstrap

**Why:** Kalau user sebut "POS" tanpa konteks, ada 2 project. Confirm dulu yang mana.
**How to apply:** Saat user minta kerjaan POS, tanya project mana. Kalau KASVER — tanya juga React lama atau MVC baru, karena keduanya masih exist di disk.
