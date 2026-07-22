---
name: CMHealth — Status Project
description: Info project CMHealth (Azure CMHealth) — stack, path, dan progress yang sudah dikerjakan
type: project
---

Project CMHealth (full name: Azure CMHealth) adalah aplikasi manajemen klaim kesehatan berbasis web.

**Path:** `D:\2. Office\MAG\Azure CMHealth`
**Stack:** ASP.NET Core MVC + Syncfusion EJ2 (Razor Tag Helpers) + jQuery
**Layout:** `_LayoutNoSidebar.cshtml` untuk halaman transaksi

**Yang sudah dikerjakan (2026-07-22):**
- `DataPemohonClaim.cshtml` — form Data Permohonan Claim
  - Popup konfirmasi simpan → EJ2 Dialog (`confirmSimpanDialog`)
  - Notifikasi hasil simpan (sukses/gagal/error) → EJ2 Dialog reusable (`notifDialog`) via `showNotif(header, msg)`
  - Refactor `btnSaveReg()` → 3 fungsi: `btnSaveReg`, `onConfirmSimpan`, `doSaveReg`
  - Fix bug `btnBack` class di tombol Batal dialog → `data-no-navigate` + `:not([data-no-navigate])` selector

**Why:** Enhancement UI — mengganti native `alert()`/`confirm()` dengan EJ2 Dialog untuk konsistensi visual.
**How to apply:** Kalau ada task lain di CMHealth, gunakan pattern EJ2 Dialog yang sama (lihat `confirmSimpanDialog` dan `notifDialog` di file tersebut sebagai referensi).
