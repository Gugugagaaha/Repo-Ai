---
name: ORMS BJJ (RMOnline) — Status Analisis
description: Status dan temuan analisis app ORMS BJJ untuk keperluan refactor/rewrite
type: project
originSessionId: 38fcfed5-df71-4128-abf7-bc04f5331d92
---
# ORMS BJJ — RMOnline_NEW2

**Path project:** `D:\2. Office\5. Ai\RMOnline_NEW2`  
**Log analisis:** `D:\2. Office\5. Ai\RMOnline_NEW2\ANALYSIS_LOG.md`  
**Tujuan:** Analisis kekurangan → refactor atau rewrite

**Why:** User ingin memahami dulu secara menyeluruh sebelum refactor/rewrite. Log harus diisi tiap sesi.

**How to apply:** Baca ANALYSIS_LOG.md di awal setiap sesi yang berkaitan dengan project ini.

---

## Tech Stack
- ASP.NET WebForms (.NET 4.8)
- Ext.NET 4.8.3 (UI utama) + Telerik (legacy)
- SQL Server, raw SQL (tidak ada ORM)
- Auth: custom token + Microsoft Entra (Azure AD)
- Tidak ada service layer, tidak ada repository pattern

---

## Status Fase Analisis (per 2026-07-17)

| Fase | Status |
|---|---|
| Phase 1 — Project Structure | ✅ SELESAI |
| Phase 2 — Architecture & Flow | ✅ SELESAI |
| Phase 3 — Layer-by-layer Analysis | ✅ SELESAI |
| Phase 4 — Issues Classified | ✅ SELESAI |
| Phase 5 — Refactor/Rewrite Rec. | ✅ SELESAI |

---

## Temuan Kritis (sudah teridentifikasi)

**Security:**
- [SEC-01] ⛔ Credentials hardcoded di Web.config (SA password, mail pass, Azure AD secret)
- [SEC-02] ⛔ SQL Injection sistemik — string concatenation langsung ke SQL di seluruh codebase
- [SEC-03] 🔴 Session fixation check dinonaktifkan (di-comment di Global.asax.cs)
- [SEC-04] 🔴 customErrors mode="Off" — error detail terekspos
- [SEC-05] 🔴 CSP header salah format (colon setelah default-src)

**Architecture:**
- [ARCH-01] ⛔ God class clsGeneral.cs (306KB, berisi segalanya)
- [ARCH-02] ⛔ SQL Injection pattern sistemik di 100+ pages
- [ARCH-03] 🔴 Code duplication login flow ~95% (copy-paste untuk Entra vs token login)
- [ARCH-04] 🔴 100+ ASPX pages flat di root tanpa struktur module
- [ARCH-05] 🔴 Multiple version pages (V2/V3/V4) tanpa deprecation strategy
- [ARCH-10] 🟡 Empty catch blocks di mana-mana — tidak ada error logging
- [ARCH-11] 🟡 Tidak ada service layer / repository pattern — tidak testable

---

## Status Akhir Analisis (per 2026-07-17) — SEMUA FASE SELESAI

**Keputusan:** REWRITE (bukan refactor)
**Strategy:** Strangler Fig — incremental per modul
**Stack baru:** ASP.NET Core .NET 8 + Dapper + React + TypeScript
**Database:** SQL Server dipertahankan
**Estimasi:** 12–15 bulan (tim 3–4 orang)

**Quick wins yang bisa dikerjakan sekarang (< 3 jam, tanpa sentuh business logic):**
1. Fix CSP header typo di Web.config
2. customErrors → RemoteOnly
3. Uncomment X-Content-Type-Options
4. debug="true" → false
5. Uncomment session fixation check di Global.asax.cs
6. Pindahkan credentials ke env vars / Key Vault

**Yang salvageable dari kode lama:**
- Model/ DTOs (60+ POCO class) — port langsung
- Database schema + stored procedures — pertahankan
- Business validation logic (clsValidation.cs) — extract & port
- Email templates (email/ folder) — reuse
